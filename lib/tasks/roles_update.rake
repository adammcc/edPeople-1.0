namespace :db do
  desc "Updates roles"
  task :update_roles => :environment do

    new_role_names = ['Administrator', 'Teacher', 'Parent Coordinator',' Pupil Personnel Services']
    old_roles = Role.all
    old_role_names = old_roles.pluck(:name)

    for name in new_role_names
      next if old_role_names.include? name
      new_role = Role.create(name: name)
    end

    old_roles.each do |old_role|
      old_role.delete if !new_role_names.include? old_role.name
    end

  end
end