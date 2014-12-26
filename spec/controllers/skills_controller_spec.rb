require 'spec_helper'

describe SkillsController do
  before(:each) do
    @user = FactoryGirl.create(:user, first_name: 'Joe', last_name: 'User' )
    @skill = FactoryGirl.create(:skill, name: 'A Skill')
    sign_in @user
  end

  describe :create do
    it 'creates a new skill and associates it with the current user' do
      expect{ post :create, skill: { name: 'Some Skill' }, format: :js }.to change(Skill, :count).by(1)
      expect(@user.reload.skills.first.name).to eq('Some Skill')
    end
  end

  describe :destroy do
    it 'deletes a skill' do
      expect{ delete :destroy, id: @skill.id, format: :js }.to change(Skill, :count).by(-1)
    end
  end
end