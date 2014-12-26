require 'spec_helper'

describe SubjectsController do
  before(:each) do
    @user = FactoryGirl.create(:user, first_name: 'Joe', last_name: 'User' )
    @subject = FactoryGirl.create(:subject, name: 'A Subject')
    sign_in @user
  end

  describe :create do
    it 'associates an existing subject with the current user' do
      post :create, subject: { id: @subject }, format: :js

      expect(@user.reload.subjects.first.name).to eq('A Subject')
    end
  end

  describe :destroy do
    it 'removes an association between a subject and the current user' do
      delete :destroy, id: @subject.id, format: :js

      expect(@user.reload.subjects).to be_empty
    end
  end
end