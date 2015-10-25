class JobPostsController < ApplicationController

  def index
    @search_term = params[:search]
    @roles = Role.all.asc(:name)
    @locations = Location.all.asc(:name)

    role_ids = params[:filter_by_roles]
    location_ids = params[:filter_by_locations]

    if @search_term.present? || role_ids || location_ids
      if @search_term.present?
        jobs = JobPost.full_text_search(@search_term)
      else
        jobs = JobPost.all
      end

      if role_ids && location_ids
        location_names = Location.in(id: location_ids).pluck(:name).map { |name| Regexp.new(name, 'i')}
        role_names = Role.in(id: role_ids).pluck(:name).map { |name| Regexp.new(name, 'i')}

        jobs_filtered_by_location = jobs.where( location_id: { :$in => location_ids } ) + jobs.where( indeed_location: { :$in => location_names } )
        jobs_filtered_by_location = JobPost.all.in( id: jobs_filtered_by_location.map(&:id) )
        jobs = jobs_filtered_by_location.where( role_ids: { :$in => location_names } ) + jobs_filtered_by_location.where( title: { :$in => role_names } )

        @jobs = jobs.sort_by(&:created_at).reverse.paginate(page: params[:page], per_page: 10)
      elsif role_ids || location_ids
        if location_ids
          location_names = Location.in(id: location_ids).pluck(:name).map { |name| Regexp.new(name, 'i')}
          jobs = jobs.where( location_id: { :$in => location_ids } ) + jobs.where( indeed_location: { :$in => location_names } )
        end

        if role_ids
          role_names = Role.in(id: role_ids).pluck(:name).map { |name| Regexp.new(name, 'i')}
          jobs = jobs.where( role_id: { :$in => role_ids }) + jobs.where( title: { :$in => role_names } )
        end

        @jobs = jobs.sort_by(&:created_at).reverse.paginate(page: params[:page], per_page: 10)
      else
        @jobs = jobs.desc(:created_at).paginate(page: params[:page], per_page: 10)
      end
    else
      @jobs = JobPost.desc(:created_at).paginate(page: params[:page], per_page: 10)
    end
  end

  def show
    @job = JobPost.find(params[:id])
    job_title = @job.title
    job_location = @job.location
    @similar_jobs = JobPost.ne(id: @job.id).or(title: (/#{job_title}/i)).or(location: (/#{job_location}/i)).shuffle.first(5)
    @random_jobs = JobPost.all.shuffle.first(5) if @similar_jobs.blank?
  end

  def new
    @job_post = JobPost.new()
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