class EpMailer < ActionMailer::Base

  default from: 'edPeople <no-reply@edPeople.com>'

  def user_message(recipient, sender, message)
    @recipient = recipient
    @sender = sender
    @message = message
    mail(
      to: @recipient.email,
      subject: "New message form #{@sender.name}"
    )
  end

end
