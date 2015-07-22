namespace :db do
  desc "Geocodes all job posts"
  task :geocode_jobs => :environment do

    JobPost.all.each do |job|
      job.geocode
      job.save
      puts "Geocoded ----> #{job.title}"
      sleep 1
    end
  end
end