require 'spec_helper'

describe User do

  describe :name do
    it "will return a user\'s first and last name" do
      user = FactoryGirl.create(:user, first_name: 'Mister', last_name: 'Magoo')

      expect(user.name).to eq('Mister Magoo')
    end
  end

    describe :update_name do
    it "will update a user\'s name" do
      user = FactoryGirl.create(:user, first_name: 'Mister', last_name: 'Magoo')
      user.update_name('Mister New Lastname')

      expect(user.name).to eq('Mister New Lastname')
    end
  end

  describe :remove_all_friends do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @friend = FactoryGirl.create(:user)
      @pending_invited = FactoryGirl.create(:user)
      @pending_invited_by = FactoryGirl.create(:user)
      @user.invite @friend
      @friend.approve @user
      @user.invite @pending_invited
      @pending_invited_by.invite @user
    end

    it 'removes a user\'s friends' do
      expect(@user.reload.friends.first).to eq(@friend)
      @user.remove_all_friends

      expect(@user.reload.friends).to eq([])
    end

    it 'removes a user\'s pending invited friends' do
      expect(@user.reload.pending_invited.first).to eq(@pending_invited)
      @user.remove_all_friends

      expect(@user.reload.friends).to eq([])
    end

    it 'removes a user\'s pending invited by friends' do

    end
  end

  describe :connect_to_linkedin do
    pending 'Connects and syncs with linkedin' do
    end
  end

  describe :sync_with_linkedin do
    pending 'syncs with linkedin' do
    end
  end

  describe :upload_avatar_to_s3 do
    pending 'uploads a user\'s profile pic to S3' do
    end
  end

  describe :upload_resume_to_s3 do
    pending 'uploads a user\'s resume to S3' do
    end
  end

  describe :delete_resume_from_s3 do
    pending 'delets a user\'s resume from S3' do
    end
  end

end
