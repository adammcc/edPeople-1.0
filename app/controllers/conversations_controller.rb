class ConversationsController < ApplicationController

  def index
    @user = current_user

    if params[:trash] == 'true'
      @trash = params[:trash] == 'true'
      @conversations = @user.conversations.where(removed_for_ids: { '$in' => [current_user.id.to_s] })
    else
      @conversations = @user.conversations.where(removed_for_ids: { '$nin' => [current_user.id.to_s] })
    end

    @search_term = params[:search]
    @unread_messages_count = @user.unread_messages_count(@conversations)

    if @search_term.present?
      @conversations = @conversations.full_text_search(@search_term)
    end
    @conversations = @conversations.paginate(page: params[:page], per_page: 10)
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.desc(:created_at).paginate(page: params[:page], per_page: 10)
    @recipient = @conversation.users.ne(id: current_user.id).first

    @conversation.messages.each do |message|
      if !message.viewed_by_ids.include?(current_user.id)
        message.viewed_by_ids << current_user.id
        message.save
      end
    end
  end

  def destroy
    convo = Conversation.find(params[:id])
    convo.removed_for_ids << params[:user_id]

    if convo.save
      flash[:notice] =  "Conversation deleted"
    else
      flash[:alert] =  "Error!"
    end

    redirect_to user_conversations_path(current_user)
  end

  def restore
    convo = Conversation.find(params[:id])
    convo.removed_for_ids.delete(params[:user_id])

    if convo.save
      flash[:notice] =  "Conversation restored"
    else
      flash[:alert] =  "Error!"
    end

    redirect_to user_conversations_path(current_user)
  end
end
