class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @colleges = College.all
    @experiences = @user.experiences

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if params[:user][:experience]
      experience = @user.experiences.find(params[:user][:experience][:id])
      experience.update_attributes(params[:user][:experience])
      experience.save
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_experience
    @user = User.find(params[:id])

    experience = @user.experiences.create(params[:user][:experience])
    experience.save

    redirect_to :back
  end

  def add_skill
    user = current_user
    skill = Skill.create(name: params[:user][:skill][:name])

    user.skills << skill

    redirect_to :back

  end

  def invite_friend
    inviter = current_user
    invitee = User.find(params[:id])

    inviter.invite invitee

    redirect_to :back
  end

  def approve_friend
    invitee = current_user
    inviter = User.find(params[:id])

    invitee.approve inviter
    invitee.save

    redirect_to :back
  end

  def remove_deny_friend
    friend = current_user
    bad_friend = User.find(params[:id])

    friend.remove_friendship bad_friend
    friend.save

    redirect_to :back
  end

  def add_avatar
    user = User.find(params[:id])
    avatar = params[:user][:avatar]

    user.avatar = avatar
    user.save

    upload_avatar_to_s3(user, avatar)

    redirect_to :back
  end 

   # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private

  def upload_avatar_to_s3(user, avatar)
    s3 = AWS::S3.new()
    bucket_path = Ep::Lib.bucket_path('avatar')
    object_path = avatar.original_filename

    bucket = s3.buckets[bucket_path]
    if !bucket.exists?
      bucket = s3.buckets.create(bucket_path)
    end

    # TODO: public_read probably not the best thing to do here
    bucket.objects.create(user.id, avatar.tempfile.read(), acl: :public_read)
  end

end
