namespace :db do
  desc "Pull old users from google spredsheet "
  task :pull_old_data => :environment do
    importer = Ep::Importer.new
    importer.pull_users
    importer.pull_orgs
  end
end
