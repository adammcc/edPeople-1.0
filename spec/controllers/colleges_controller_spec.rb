require 'spec_helper'

describe CollegesController do
  before(:each) do
    @user = FactoryGirl.create(:user, first_name: 'Joe', last_name: 'User' )
    @college = FactoryGirl.create(:college, name: 'Some College')
    sign_in @user
  end

  describe :create do
    it 'creates a new college if no college exists with the same name, and associates it with the current user throufgh a CollegeInfo' do
      expect{ post :create,
        college: {
          name: 'Some New College',
          degree_type: 'BS',
          major: 'Art Education',
          start_date: Date.today - 7.days,
          end_date: Date.today
        },
        format: :js
      }.to change(College, :count).by(1)

      expect{ post :create,
        college: {
          name: 'Some New College',
          degree_type: 'BS',
          major: 'Art Education',
          start_date: Date.today - 7.days,
          end_date: Date.today
        },
        format: :js
      }.to change(CollegeInfo, :count).by(1)

      expect(@user.reload.college_infos.first.college.name).to eq('Some New College')
    end

    it 'creates a new college_info if college exists already' do
      expect{ post :create,
        college: {
          name: 'Some College',
          degree_type: 'MS',
          major: 'Math Education',
          start_date: Date.today - 7.days,
          end_date: Date.today
        },
        format: :js
      }.to change(CollegeInfo, :count).by(1)

      expect(@user.reload.college_infos.first.college.name).to eq('Some College')
    end
  end
end