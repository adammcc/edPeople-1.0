require 'spec_helper'

describe CollegeInfosController do
  before(:each) do
    @user = FactoryGirl.create(:user, first_name: 'Joe', last_name: 'User' )
    @college = FactoryGirl.create(:college, name: 'EPU')
    @college_2 = FactoryGirl.create(:college, name: 'epPeople College')
    @college_info = FactoryGirl.create(:college_info, name: 'CI', college: @college)
    sign_in @user
  end

  describe :update do
    it 'updates a college_info' do
      put :update, id: @college_info.id, college_info: { name: 'EPU', start_date: "2015-01-10", end_date: "2015-01-11"}, format: :js

      expect(@college_info.reload.start_date).to eq("2015-01-10")
      expect(@college_info.reload.end_date).to eq("2015-01-11")
    end

    it 'create\'s a new college_info and adds it to another college if the name is changed' do
      put :update, id: @college_info.id, college_info: { name: 'epPeople College', start_date: "2015-01-10", end_date: "2015-01-11"}, format: :js

      expect(@college_2.college_infos.first.start_date).to eq("2015-01-10")
      expect(@college_2.college_infos.first.end_date).to eq("2015-01-11")
    end

    it 'create\'s a new college and college_info if the name is changed and there is no existing college with that name' do
      put :update, id: @college_info.id, college_info: { name: 'New Name', start_date: "2015-02-10", end_date: "2015-03-11"}, format: :js

      expect(College.all.count).to eq(3)
      expect(College.last.college_infos.first.start_date).to eq("2015-02-10")
      expect(College.last.college_infos.first.end_date).to eq("2015-03-11")
    end
  end

  describe :destroy do
    it 'deletes a college_info' do
      expect{ delete :destroy, id: @college_info.id, format: :js }.to change(CollegeInfo, :count).by(-1)
    end
  end
end