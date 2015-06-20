class MessagesController < ApplicationController

  def create
    @user =  current_user
    recipient_id = params[:recipient_id]
    recipient = User.find(recipient_id)
    if params[:in_convo]
      @conversation = Conversation.find(params[:convo_id])

      @conversation.removed_for_ids.clear
      @conversation.save

      if @message = @conversation.messages.create(params[:message].merge({user: @user, viewed_by_ids: [@user.id]}))
        EpMailer.user_message(recipient, @user, @message.note).deliver if recipient.allows_one_on_one_message_email
      end
    elsif recipient_id
      @conversation = @user.conversations.where(user_ids: recipient_id).first
      @conversation = Conversation.create(user_ids: [recipient_id, @user.id]) if !@conversation.present?

      @conversation.removed_for_ids.clear
      @conversation.save

      if @message = @conversation.messages.create(params[:message].merge(user: @user))
        EpMailer.user_message(recipient, @user, @message.note).deliver if recipient.allows_one_on_one_message_email
      end
      redirect_to user_conversation_path(@user, @conversation)
    end
  end
end
