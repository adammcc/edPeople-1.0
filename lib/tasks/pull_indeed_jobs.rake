namespace :db do
  desc "Pulls job posts form indeed"
  task :pull_indeed_jobs => :environment do
    indeed_response = HTTParty.get('http://api.indeed.com/ads/apisearch?publisher=9638279391529269&q=school+teacher&l=new_york%2C+ny&sort=&radius=&st=&jt=&start=&limit=50&fromage=&filter=&latlong=1&co=us&chnl=&userip=1.2.3.4&useragent=Mozilla/%2F4.0%28Firefox%29&v=2')
    indeed_response.first.last["results"]["result"].each do |job|
      unless JobPost.where(indeed_key: job["jobkey"]).any?
        job = JobPost.create(
          indeed_key: job["jobkey"],
          indeed_date: job["date"],
          title: job["jobtitle"],
          indeed_location: job["formattedLocation"],
          organization: job["company"],
          indeed_url: job["url"],
          description: job["snippet"]
        )
      end
    end
  end
end
