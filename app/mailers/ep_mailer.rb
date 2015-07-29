class EpMailer < ActionMailer::Base

  default from: 'edPeople <no-reply@edPeople.com>'

  def user_message(recipient, sender, message)
    @recipient = recipient
    @sender = sender
    @message = message
    @host = ActionMailer::Base.default_url_options[:host]
    mail(
      to: @recipient.email,
      subject: "New message from #{@sender.name}"
    )
  end

  def friend_invitation(friend, user)
    @friend = friend
    @user = user
    @host = ActionMailer::Base.default_url_options[:host]
    mail(
      to: @friend.email,
      subject: "New connection request from #{@user.name}"
    )
  end

  def original_user_password_reset(user, password)
    @user = user
    @password = password
    @host = ActionMailer::Base.default_url_options[:host]
    mail(
      :to => user.email,
      :subject => 'Password Reset Notification'
    )
  end

end
