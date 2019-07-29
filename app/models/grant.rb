class Grant < Base

  attr_accessor :project_id, :resource_id

  def save
    scoped_project = project_id.split(':')[-1]
    scoped_resource = resource_id.split(':')[-1]
    # raise "project_id: #{scoped_project}, resource_id: #{scoped_resource}"
    api = Database.api
    puts "namespace: #{scoped_project.split('/')[0...-1].join('/')}"
    puts "policy: #{policy(scoped_project.split('/')[-1], scoped_resource)}"
    #api.load_policy(scoped_project.split('/')[0...-1].join('/'), policy(scoped_project.split('/')[-1], scoped_resource.split('/')[-1]))
    api.load_policy('root', policy(scoped_project, scoped_resource))
  end

  def policy(project_id, resource_id)
    <<-POLICY
- !grant
  member: !layer #{project_id}
  role: !group #{resource_id}/secrets-users
POLICY
  end
end
