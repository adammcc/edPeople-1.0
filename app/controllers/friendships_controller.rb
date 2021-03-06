class FriendshipsController < ApplicationController

  def create
    @user = current_user
    @friend = User.find(params[:id])

    if @user.invite @friend
      flash[:notice] = "Request sent."
      FriendInvitationMailerJob.new.async.perform(@friend, @user) if @friend.allows_friend_request_email
    else
      flash[:notice] = "Error"
    end
  end

  def update
    @user = current_user
    @friend = User.find(params[:id])
    @suggestions =Ep::Lib.get_suggestions(@user)

    current_user.approve @friend
    current_user.save
  end

  def destroy
    @user = current_user
    @friend = User.find(params[:id])
    @suggestions = Ep::Lib.get_suggestions(@user)

    current_user.remove_friendship @friend
    current_user.save
  end
end