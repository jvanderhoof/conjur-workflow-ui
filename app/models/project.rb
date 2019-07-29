class Project < Base
  attr_accessor :name, :namespace, :id

  class << self
    def find(id)
      instantiate(api.resource(id))
    end

    def instantiate(app)
      full_name = app.attributes['id'].split(':').last
      database = Project.new(
        id: app.id.id,
        name: full_name.split('/')[-1],
        namespace: full_name.split('/')[0...-1].join('/')
      )
    end

    def all
      api.resources(kind: 'policy', search: 'application').map do |db|
        if db.attributes['annotations'].select { |a| a['name'] == 'resource_type' && a['value'] == 'application' }.present?
          instantiate(db)
        end
      end.compact.sort { |x,y| x.id <=> y.id }
    end
  end

  def resources
    puts "id: #{id}"
    Base.api.role(id).memberships.map{|m| m.id }.select{|m| m.id.include?(':group:')}.map{|m| m.id.scan(/group:(.+)\/secrets-users/).first.last}
  end

  def save
    Base.api.load_policy(namespace, policy(name))
  end

  def update
    raise 'update not implemented'
  end

  def policy(name)
    <<-POLICY
- !policy
  id: #{name}
  annotations:
    resource_type: application
  body:
  - !layer

  - !host-factory
    layer: [ !layer ]
POLICY
  end
end
