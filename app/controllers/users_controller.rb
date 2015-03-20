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
    @suggestions = get_suggestions(@user)
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

    if params[:user][:password].blank?
      params[:user].delete(:password).delete(:password_confirmation)
      params[:user].delete(:password_confirmation)
    end

    if name.present?
      if @user.update_name(params[:user][:name])
        flash[:notice] =  "Saved!"
      else
        flash[:alert] =  "Error!"
      end
      render nothing: true
    else
      if @user.update_attributes(params[:user])
        if params[:user][:password].present?
          sign_in(@user, :bypass => true)
          @user.set(has_linkedin_account: false)
        end
        flash[:notice] = "Saved!"
        redirect_to user_path(@user)
      else
        redirect_to edit_user_path(@user)
        flash[:alert] = "Error!"
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

  def invite_friend
    @user = current_user
    @friend = User.find(params[:id])

    if @user.invite @friend
       EpMailer.friend_invitation(@friend, @user).deliver if @friend.allows_friend_request_email
    end
  end

  def approve_friend
    @user = current_user
    @friend = User.find(params[:id])
    @suggestions = get_suggestions(@user)

    current_user.approve @friend
    current_user.save
  end

  def remove_deny_friend
    @user = current_user
    @friend = User.find(params[:id])
    @suggestions = get_suggestions(@user)

    current_user.remove_friendship @friend
    current_user.save
  end

  def add_avatar
    user = User.find(params[:id])
    if params[:user].present?
      avatar = params[:user][:avatar]

      user.avatar = avatar
      user.save
    end

    redirect_to :back
  end

  def add_resume
    user = User.find(params[:id])
    if !params[:resume].nil?
      resume = params[:resume]
      user.upload_resume_to_s3(user, resume)
      user.has_resume = true
      user.save
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

  private

  def get_suggestions(user)
    if user.has_colleges?
      college_user_ids = []
      user.colleges.each do |college|
        college_user_ids << college.user_ids
      end
      college_user_ids.flatten!
      college_user_suggestions = User.in(id: college_user_ids).ne(id: user.id, as_org: true)
    else
      college_user_suggestions = []
    end

    if user.has_subjects?
      subject_user_ids = []
      user.subjects.each do |subject|
        subject_user_ids << subject.user_ids
      end
      subject_user_ids.flatten!
      subject_user_suggestions = User.in(id: subject_user_ids).ne(id: user.id, as_org: true)
    else
      subject_user_suggestions = []
    end

    if user.is_admin?
      admin_role = Role.where(name: 'Administrator').first
      role_user_suggestions = admin_role.users.ne(id: user.id, as_org: true)
      role_user_suggestions = [] if role_user_suggestions.blank?
    else
      role_user_suggestions = []
    end

    @suggestions = (college_user_suggestions + subject_user_suggestions + role_user_suggestions).shuffle.first(3)
    @suggestions = User.all.ne(id: user.id, as_org: true).shuffle.first(3) if @suggestions.blank?
  end

end
