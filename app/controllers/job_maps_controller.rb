class JobMapsController < ApplicationController

  def index
    grouped_jobs = JobPost.ne(user_id: nil).where(indeed_key: nil).group_by { |job| job.user_id }
    grouped_indeed_jobs = JobPost.ne(indeed_key: nil).group_by { |job| job.organization }

    @jobs = []
    grouped_jobs.each do |job|
      ids = job[1].map { |job| job.id.to_s }
      titles = job[1].map { |job| job.title }
      coords = job[1].first.coordinates
      name = job[1].first.user.name
      org_user_id = job[1].first.user.id
      if coords.present?
        @jobs << { org_name: name, org_user_id: org_user_id, job_ids: ids, titles: titles, coords: coords }
      end
    end

    grouped_indeed_jobs.each do |job|
      ids = job[1].map { |job| job.id.to_s }
      titles = job[1].map { |job| job.title }
      coords = job[1].first.coordinates
      if coords.present?
        @jobs << { org_name: job[0], job_ids: ids, titles: titles, coords: coords }
      end
    end
  end

end