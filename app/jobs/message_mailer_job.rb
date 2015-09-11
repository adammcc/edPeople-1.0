class MessageMailerJob
  include SuckerPunch::Job

  def perform(to_user, from_user, note)
   EpMailer.user_message(to_user, from_user, note).deliver
  end
end