class FriendInvitationMailerJob
  include SuckerPunch::Job

  def perform(to_user, from_user)
    EpMailer.friend_invitation(to_user, from_user).deliver
  end
end