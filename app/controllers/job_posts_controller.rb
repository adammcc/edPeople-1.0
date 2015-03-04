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
         @jobs = @jobs.in(location_id: location_ids).in(role_id: role_ids)
      elsif role_ids || location_ids
        @jobs = @jobs.in(role_id: role_ids) if role_ids
        @jobs = @jobs.in(location_id: location_ids) if location_ids
      end
      @jobs = @jobs.asc(:created_at).paginate(page: params[:page], per_page: 10)
    else
      @jobs = JobPost.asc(:created_at).paginate(page: params[:page], per_page: 10)
    end
  end

  def show
    @job = JobPost.find(params[:id])
    job_title = @job.title
    job_location = @job.location
    @similar_jobs = JobPost.ne(id: @job.id).or(title: (/#{job_title}/i)).or(location: (/#{job_location}/i)).shuffle.first(5)
    @random_jobs = JobPost.all.shuffle.first(5) if @similar_jobs.blank?
  end

  def create
    @job_post = JobPost.create(params[:job_post])
    @job_post.user = current_user
    if @job_post.save
      flash[:notice] =  "Saved!"
    else
      flash[:alert] =  "Error!"
    end

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