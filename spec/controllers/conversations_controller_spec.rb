require 'spec_helper'

describe ConversationsController do
  before(:each) do
    @user = FactoryGirl.create(:user, first_name: 'Joe', last_name: 'User' )
    @recipient = FactoryGirl.create(:user, first_name: 'Fred', last_name: 'User' )
    @recipient_2 = FactoryGirl.create(:user, first_name: 'Sue', last_name: 'User' )
    @conversation = FactoryGirl.create(:conversation, user_ids: [@user.id, @recipient.id])
    @conversation_2 = FactoryGirl.create(:conversation, user_ids: [@user.id, @recipient_2.id])
    @user.conversations << @conversation
    @user.conversations << @conversation_2
    @user.save
    sign_in @user
  end

  describe :show do
    it "renders a conversation\'s show page" do
      get :show, id: @conversation.id, user_id: @user.id

      expect(response).to render_template(:show)
    end
  end

  describe :index do
    it "returns all a user\'s conversations" do
      get :index, user_id: @user.id

      expect(response).to render_template(:index)
      expect(assigns(:conversations).to_a).to include(@conversation)
      expect(assigns(:conversations).to_a).to include(@conversation_2)
    end

    it "returns correct conversations when a search term is entered" do
      get :index, user_id: @user.id, search: 'Fred'

      expect(assigns(:conversations).to_a).to eq([@conversation])
      expect(assigns(:conversations).to_a).to_not include(@conversation_2)
    end
  end
end