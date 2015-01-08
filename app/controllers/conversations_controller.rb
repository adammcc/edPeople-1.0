class ConversationsController < ApplicationController

  def index
    @user = current_user
    @conversations = @user.conversations
    @search_term = params[:search]
    @unread_messages_count = @user.unread_messages_count(@conversations)

    if @search_term.present?
      @conversations = @conversations.full_text_search(@search_term)
    end
  end

  def show
    @conversation = Conversation.find(params[:id])

    @conversation.messages.each do |message|
      if !message.viewed_by_ids.include?(current_user.id)
        message.viewed_by_ids << current_user.id
        message.save
      end
    end
  end

end
