require 'spec_helper'

describe RolesController do
  before(:each) do
    @user = FactoryGirl.create(:user, first_name: 'Joe', last_name: 'User' )
    @role = FactoryGirl.create(:role, name: 'A Role')
    sign_in @user
  end

  describe :create do
    it 'associates an existing role with the current user' do
      post :create, role: { id: @role }, format: :js

      expect(@user.reload.roles.first.name).to eq('A Role')
    end
  end

  describe :destroy do
    it 'removes an association between a role and the current user' do
      delete :destroy, id: @role.id, format: :js

      expect(@user.reload.roles).to be_empty
    end
  end
end