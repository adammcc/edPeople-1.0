class JobMapsController < ApplicationController

  def index
    grouped_jobs = JobPost.collection.aggregate([
      { "$group" => { "_id" => { "coordinates" => "$coordinates", "organization" => "$organization", "user_id" => "$user_id" }, "data" => { "$push" => { "job" => { "id" => "$_id", "title" => "$title" }}}}}
    ])

    @jobs = []
    grouped_jobs.each do |job|
      ids = job["data"].map { |job| job["job"]["id"].to_s }
      titles =  job["data"].map { |job| job["job"]["title"] }
      coords = job["_id"]["coordinates"]
      name = job["_id"]["organization"]
      user_id = job["_id"]["user_id"]


      if coords.present? && coords != [-74.0059413, 40.7127837] # TODO: figure out why all these jobs are geodcoded to these coords
        @jobs << { org_name: name, user_id: user_id, job_ids: ids, titles: titles, coords: coords }
      end
    end
  end

end