class Database < Base
  attr_accessor :url, :port, :username, :password, :name, :namespace,
                :database_type, :id

  class << self
    def instantiate(db, set_variables = false)
      full_name = db.attributes['id'].split(':').last
      db_type = db.attributes['annotations'].select{|a| a['name'] == 'resource_sub_type'}
      database = Database.new(
        id: db.id.id,
        name: full_name.split('/')[-1],
        namespace: full_name.split('/')[0...-1].join('/'),
        database_type: db_type.empty? ? '' : db_type.first['value']
      )
      if set_variables
        database.url = api.resource("#{account}:variable:#{database.namespace}/#{database.name}/url").value
        database.port = api.resource("#{account}:variable:#{database.namespace}/#{database.name}/port").value
        database.username = api.resource("#{account}:variable:#{database.namespace}/#{database.name}/username").value
        database.password = api.resource("#{account}:variable:#{database.namespace}/#{database.name}/password").value
      end
      database
    end

    def find(id)
      instantiate(api.resource(id), true)
    end

    def all
      api.resources(kind: 'policy', search: 'database').map do |db|
        if db.attributes['annotations'].select{|a| a['name'] == 'resource_type' && a['value'] == 'database'}.present?
          instantiate(db)
        end
      end.compact.sort { |x,y| x.id <=> y.id }
    end
  end

  def save
    api = Database.api
    load_policy(api, namespace, name)
    set_values(api, "#{namespace}/#{name}", url, port, username, password)
    self
  end

  def update
    api = Database.api
    set_values(api, "#{namespace}/#{name}", url, port, username, password)
    self
  end

  def set_values(api, resource_path, url, port, username, password)
    api.resource("#{Database.account}:variable:#{resource_path}/url").add_value(url)
    api.resource("#{Database.account}:variable:#{resource_path}/port").add_value(port)
    api.resource("#{Database.account}:variable:#{resource_path}/username").add_value(username)
    api.resource("#{Database.account}:variable:#{resource_path}/password").add_value(password)
  end

  def load_policy(api, namespace, resource_name)
    api.load_policy(namespace, policy(resource_name))
  end

  def policy(name)
    <<-POLICY
- !policy
  id: #{name}
  annotations:
    resource_type: database
    resource_sub_type: #{database_type}
  body:
    - &variables
      - !variable
        id: username
        annotations:
          description: Database username
      - !variable
        id: password
        annotations:
          description: Database password
      - !variable
        id: url
        annotations:
          description: Database URL
      - !variable
        id: port
        annotations:
          description: Database port

    - !group secrets-users
    - !group secrets-managers

    # secrets-users can read and execute
    - !permit
      resource: *variables
      privileges: [ read, execute ]
      role: !group secrets-users

    # secrets-managers can update (and read and execute, via role grant)
    - !permit
      resource: *variables
      privileges: [ update ]
      role: !group secrets-managers

    # secrets-managers has role secrets-users
    - !grant
      member: !group secrets-managers
      role: !group secrets-users
POLICY
  end
end
