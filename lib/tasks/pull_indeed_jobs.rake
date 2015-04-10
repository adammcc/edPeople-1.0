namespace :db do
  desc "Pulls job posts form indeed"
  task :pull_indeed_jobs => :environment do
    search_params = [
      ['school+teacher','new_york%2C+ny'],
      ['school+teacher','Rockland+County'],
      ['school+teacher','Westchester+County%2C+NY'],
      ['school+teacher','Manhattan%2C+NY'],
      ['school+teacher','Queens%2C+NY'],
      ['school+teacher','Brooklyn%2C+NY'],
      ['school+teacher','Bronx%2C+NY'],
      ['school+teacher','Staten+Island%2C+NY'],
      ['school+teacher','Hoboken%2C+NJ'],
      ['school+teacher','Long+Island%2C+NY'],
      ['school+teacher','new_york%2C+ny'],
      ['school+teacher','Rockland+County'],
      ['school+teacher','Westchester+County%2C+NY'],
      ['school+teacher','Manhattan%2C+NY'],
      ['school+teacher','Queens%2C+NY'],
      ['school+teacher','Brooklyn%2C+NY'],
      ['school+teacher','Bronx%2C+NY'],
      ['school+teacher','Staten+Island%2C+NY'],
      ['school+teacher','Hoboken%2C+NJ'],
      ['school+teacher','Long+Island%2C+NY'],
      ['school+teacher','Nyack%2C+NY'],
      ['school+principal','new_york%2C+ny'],
      ['school+principal','Rockland+County'],
      ['school+principal','Westchester+County%2C+NY'],
      ['school+principal','Manhattan%2C+NY'],
      ['school+principal','Queens%2C+NY'],
      ['school+principal','Brooklyn%2C+NY'],
      ['school+principal','Bronx%2C+NY'],
      ['school+principal','Staten+Island%2C+NY'],
      ['school+principal','Hoboken%2C+NJ'],
      ['school+principal','Long+Island%2C+NY'],
      ['school+principal','new_york%2C+ny'],
      ['school+principal','Rockland+County'],
      ['school+principal','Westchester+County%2C+NY'],
      ['school+principal','Manhattan%2C+NY'],
      ['school+principal','Queens%2C+NY'],
      ['school+principal','Brooklyn%2C+NY'],
      ['school+principal','Bronx%2C+NY'],
      ['school+principal','Staten+Island%2C+NY'],
      ['school+principal','Hoboken%2C+NJ'],
      ['school+principal','Long+Island%2C+NY'],
      ['school+principal','Nyack%2C+NY'],
      ['assistant+principal','new_york%2C+ny'],
      ['assistant+principal','Rockland+County'],
      ['assistant+principal','Westchester+County%2C+NY'],
      ['assistant+principal','Manhattan%2C+NY'],
      ['assistant+principal','Queens%2C+NY'],
      ['assistant+principal','Brooklyn%2C+NY'],
      ['assistant+principal','Bronx%2C+NY'],
      ['assistant+principal','Staten+Island%2C+NY'],
      ['assistant+principal','Hoboken%2C+NJ'],
      ['assistant+principal','Long+Island%2C+NY'],
      ['assistant+principal','new_york%2C+ny'],
      ['assistant+principal','Rockland+County'],
      ['assistant+principal','Westchester+County%2C+NY'],
      ['assistant+principal','Manhattan%2C+NY'],
      ['assistant+principal','Queens%2C+NY'],
      ['assistant+principal','Brooklyn%2C+NY'],
      ['assistant+principal','Bronx%2C+NY'],
      ['assistant+principal','Staten+Island%2C+NY'],
      ['assistant+principal','Hoboken%2C+NJ'],
      ['assistant+principal','Long+Island%2C+NY'],
      ['assistant+principal','Nyack%2C+NY'],
      ['school+counselor','new_york%2C+ny'],
      ['school+counselor','Rockland+County'],
      ['school+counselor','Westchester+County%2C+NY'],
      ['school+counselor','Manhattan%2C+NY'],
      ['school+counselor','Queens%2C+NY'],
      ['school+counselor','Brooklyn%2C+NY'],
      ['school+counselor','Bronx%2C+NY'],
      ['school+counselor','Staten+Island%2C+NY'],
      ['school+counselor','Hoboken%2C+NJ'],
      ['school+counselor','Long+Island%2C+NY'],
      ['school+counselor','new_york%2C+ny'],
      ['school+counselor','Rockland+County'],
      ['school+counselor','Westchester+County%2C+NY'],
      ['school+counselor','Manhattan%2C+NY'],
      ['school+counselor','Queens%2C+NY'],
      ['school+counselor','Brooklyn%2C+NY'],
      ['school+counselor','Bronx%2C+NY'],
      ['school+counselor','Staten+Island%2C+NY'],
      ['school+counselor','Hoboken%2C+NJ'],
      ['school+counselor','Long+Island%2C+NY'],
      ['school+counselor','Nyack%2C+NY']
    ]

    search_params.each do |param|
      indeed_response = HTTParty.get("http://api.indeed.com/ads/apisearch?publisher=9638279391529269&q=#{param[0]}&l=#{param[1]}&sort=&radius=&st=&jt=&start=&limit=50&fromage=&filter=&latlong=1&co=us&chnl=&userip=1.2.3.4&useragent=Mozilla/%2F4.0%28Firefox%29&v=2")
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

          sleep 1
          job.geocode
          job.save
        end
      end
    end

  end
end
