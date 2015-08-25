class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  autocomplete :college, :name, full: true

  def index
    @roles = Role.all.asc(:name)
    @subjects = Subject.all.asc(:name)
    @search_term = params[:search]

    role_ids = params[:filter_by_roles]
    subject_ids = params[:filter_by_subjects]

    if @search_term.present? || role_ids || subject_ids
      @users = User.just_users.asc(:created_at)
      @users = User.just_users.full_text_search(@search_term) if @search_term.present?
      if role_ids && subject_ids
        @users = @users.in(role_ids: role_ids).in(subject_ids: subject_ids)
      elsif role_ids || subject_ids
        @users = @users.in(role_ids: role_ids) if role_ids
        @users = @users.in(subject_ids: subject_ids) if subject_ids
      end
      @users = @users.asc(:created_at).paginate(page: params[:page], per_page: 10)
    else
      @users = User.just_users.asc(:created_at).paginate(page: params[:page], per_page: 10)
    end
  end

  def show
    if params[:id]
      @user = User.find params[:id]
    else
      @user = current_user
    end

    if @user.as_org
      redirect_to org_path(@user)
      return
    end

    @colleges = College.all
    @experiences = @user.experiences
    @roles = Role.all
    @subjects = Subject.all
    @suggestions = Ep::Lib.get_suggestions(@user)

    if current_user
      @conversations = @user.conversations.where(removed_for_ids: { '$nin' => [current_user.id.to_s] })
      @unread_messages_count = @user.unread_messages_count(@conversations)
    end

    if !@user.has_profile_info
      @other_people_that_have_info = User.users_with_info
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    name = params[:user][:name]
    headline = params[:user][:headline]

    if name.present?
      if @user.update_name(params[:user][:name])
        flash[:notice] =  "Saved!"
      else
        flash[:alert] =  "Error!"
      end
      render nothing: true
    elsif @user.update_attributes(params[:user].delete_if { |k, v| v.empty? })
      if params[:user][:password].present?
        sign_in(@user, :bypass => true)
        @user.set(added_password: true)
      end
      flash[:notice] = "Saved!"
      respond_to do |format|
        format.html { redirect_to user_path(@user) }
        format.json { render nothing: true }
      end
    else
      flash[:alert] = @user.errors.full_messages
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { render nothing: true }
      end
    end
  end

  def destroy
    user = User.find(params[:id])
    user.remove_all_friends
    user.destroy

    redirect_to :root
  end

  def add_password
    @user = User.find(params[:id])
  end

  def add_avatar
    user = User.find(params[:id])
    if params[:user].present?
      accepted_formats = [".jpg", ".JPG", ".tif", ".TIF", ".png", ".PNG", ".gif", ".GIF", ".jpeg", ".JPEG"]
      avatar = params[:user][:avatar]

      if accepted_formats.include? File.extname(avatar.original_filename)
        user.avatar = avatar
        user.save
      else
        flash[:notice] = "Only files with extensions .jpg  .png .tif or .gif are allowed"
      end
    end

    redirect_to :back
  end

  def add_resume
    user = User.find(params[:id])
    if !params[:resume].nil?
      accepted_formats = [".doc", ".docx", ".pdf", ".txt"]
      resume = params[:resume]

      if accepted_formats.include? File.extname(resume.original_filename)
        user.upload_resume_to_s3(user, resume)
        user.has_resume = true
        user.save
      else
        flash[:notice] = "Only files with extensions .doc, .docx, .pdf or .txt are allowed"
      end
    end

    redirect_to :back
  end

  def remove_resume
    user = User.find(params[:id])
    user.delete_resume_from_s3
    user.has_resume = false
    user.save

    redirect_to :back
  end

  def my_jobs
    @user = User.find(params[:id])
    @search_term = params[:search]

    if @search_term.present?
      jobs = @user.job_posts.full_text_search(@search_term)
    else
      jobs = @user.job_posts
    end

    @jobs = jobs.asc(:created_at).paginate(page: params[:page], per_page: 10)
  end

  private

end
