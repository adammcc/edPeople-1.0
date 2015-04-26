require 'spec_helper'

describe FriendshipsController do
  before(:each) do
    @user = FactoryGirl.create(:user, first_name: 'Joe', last_name: 'User' )
    @some_other_user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe :create do
    it 'adds a user to the current user\'s invited list' do
      put :create, id: @some_other_user.id, format: :js

      expect(@user.reload.pending_invited).to include(@some_other_user)
    end
  end

  describe :update do
    it 'allows a user to accept a freiendship request' do
      @some_other_user.invite @user

      put :update, id: @some_other_user.id, format: :js

      expect(@user.reload.friends).to include(@some_other_user)
    end
  end

  describe :destroy do
    it 'allows a user to remove a freiendship or deny a friendship request' do
      @some_other_user_2 = FactoryGirl.create(:user)
      @some_other_user.invite @user
      @user.approve @some_other_user
      @some_other_user_2.invite @user

      expect(@user.reload.friends).to include(@some_other_user)
      put :destroy, id: @some_other_user.id, format: :js
      expect(@user.reload.friends).to_not include(@some_other_user)

      expect(@user.reload.pending_invited_by).to include(@some_other_user_2)
      put :destroy, id: @some_other_user_2.id, format: :js
      expect(@user.reload.pending_invited_by).to_not include(@some_other_user_2)
    end
  end
end