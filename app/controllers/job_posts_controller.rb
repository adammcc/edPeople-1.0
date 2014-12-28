class JobPostsController < ApplicationController

  def index
    @jobs = JobPost.all.desc(:created_at)
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