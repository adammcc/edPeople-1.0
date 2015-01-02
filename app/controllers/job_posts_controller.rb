class JobPostsController < ApplicationController

  def index
    @search_term = params[:search]
    @roles = Role.all.asc(:name)
    @locations = Location.all.asc(:name)

    role_ids = params[:filter_by_roles]
    location_ids = params[:filter_by_locations]

    if @search_term.present? || role_ids || location_ids
     @jobs = JobPost.asc(:created_at)
     @jobs = JobPost.full_text_search(@search_term) if @search_term.present?
      if role_ids && location_ids
        jobs_by_locations_then_roles = @jobs.in(location_ids: location_ids).in(role_ids: role_ids)
        @jobs = jobs_by_locations_then_roles
      elsif role_ids|| location_ids
        jobs_by_role = @jobs.in(role_id: role_ids) if role_ids
        jobs_by_location = @jobs.in(location_id: location_ids) if location_ids
        @jobs = jobs_by_role ||= [] + jobs_by_location ||= []
      end
    else
     @jobs = JobPost.asc(:created_at)
    end
  end

  def show
    @job = JobPost.find(params[:id])
    @jobs = JobPost.all.limit(5)
  end

  def create
    @job_post = JobPost.create(params[:job_post])

    redirect_to job_post_path(@job_post)
  end

  def update
    @job_post = JobPost.find(params[:id])
    @job_post.update_attributes(params[:job_post])
  end

  def destroy
    @job_post = JobPost.find(params[:id])
    @job_post.destroy

    redirect_to job_posts_path
  end
end