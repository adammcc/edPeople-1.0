require 'spec_helper'

describe MessagesController do
  before(:each) do
    @user = FactoryGirl.create(:user, first_name: 'Joe', last_name: 'User' )
    @recipient = FactoryGirl.create(:user, first_name: 'Fred', last_name: 'User' )
    @recipient_2 = FactoryGirl.create(:user, first_name: 'Sue', last_name: 'User' )
    @conversation = FactoryGirl.create(:conversation, user_ids: [@user.id, @recipient.id])
    sign_in @user
  end

  describe :create do
    it 'creates a new message and adds it to an existing conversation if no in_convo' do
      expect{ post :create, convo_id: @conversation.id, message: { note: 'Sup?' }, recipient_id: @recipient.id, in_convo: true, format: :js }.to change(Message, :count).by(1)
      expect(@conversation.reload.messages.first.note).to eq('Sup?')
    end

    it 'creates a new conversation and message if there is a not in_convo' do
      expect{ post :create, recipient_id: @recipient_2.id, message: { note: 'Hey what\'s up?' }, format: :js }.to change(Message, :count).by(1)
      expect(Conversation.last.reload.messages.first.note).to eq('Hey what\'s up?')
      expect(Conversation.all.count).to eq(2)
    end
  end
end