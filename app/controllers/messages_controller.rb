class MessagesController < ApplicationController

  def create
    user = current_user
    recipient_id = params[:recipient_id]
    if recipient_id
      @conversation = current_user.conversations.where(user_ids: recipient_id).first
      if @conversation.present?
        @conversation.messages.create(params[:message].merge(user: current_user))
      else
        @conversation = Conversation.create(user_ids: [recipient_id, current_user.id])
        @conversation.messages.create(params[:message].merge(user: current_user))
      end
      redirect_to user_conversation_path(current_user, @conversation)
    else
      @conversation = Conversation.find(params[:convo_id])
      @conversation.messages.create(params[:message].merge({user: user, viewed_by_ids: [user.id]}))
      @conversation.save
    end
  end
end