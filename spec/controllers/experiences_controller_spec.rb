require 'spec_helper'

describe ExperiencesController do
  before(:each) do
    @user = FactoryGirl.create(:user, first_name: 'Joe', last_name: 'User' )
    @experience = FactoryGirl.create(:experience, title: 'Some experience')
    sign_in @user
  end

  describe :create do
    it 'creates a new experience' do
      expect{ post :create,
        experience: {
          title: 'Some New Experience',
          start_date: Date.today - 7.days,
          end_date: Date.today
        },
        format: :js
      }.to change(Experience, :count).by(1)
    end
  end

  describe :update do
    it 'updates an experience' do
      put :update, id: @experience.id, experience: {title: 'New Title'}, format: :js

      expect(@experience.reload.title).to eq('New Title')
    end
  end


  describe :destroy do
    it 'deletes an experience' do
      expect{ delete :destroy, id: @experience.id, format: :js }.to change(Experience, :count).by(-1)
    end
  end
end