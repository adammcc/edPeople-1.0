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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
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

    if name.present?
      @user.update_name(params[:user][:name])
      render nothing: true
    else
      respond_to do |format|
        if @user.update_attributes(params[:user])
          if params[:user][:password].present?
            sign_in(@user, :bypass => true)
            @user.set(has_linkedin_account: false)
          end
          format.html { redirect_to @user, notice: 'Account successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
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
       EpMailer.friend_invitation(@friend, @user).deliver
    end
  end

  def approve_friend
    @user = current_user
    @friend = User.find(params[:id])

    current_user.approve @friend
    current_user.save
  end

  def remove_deny_friend
    @user = current_user
    @friend = User.find(params[:id])

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
end
