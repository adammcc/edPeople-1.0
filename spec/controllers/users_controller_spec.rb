require 'spec_helper'

describe UsersController do
  before(:each) do
    @user = FactoryGirl.create(:user, first_name: 'Joe', last_name: 'User' )
    @some_other_user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe :show do
    it "renders a user\'s profile" do
      get :show, id: @user.id

      expect(response).to render_template(:show)
    end
  end

  describe :index do
    it "returns all users" do
      get :index

      expect(response).to render_template(:index)
      expect(assigns(:users).to_a).to include(@user)
      expect(assigns(:users).to_a).to include(@some_other_user)
    end

    context 'when searching and filtering' do
      before(:each) do
        @subject = FactoryGirl.create(:subject, name: 'Art')
        @role = FactoryGirl.create(:role, name: 'Teacher')
        @user.roles << @role
        @user.subjects << @subject
      end

      it "returns correct users when a search term is entered" do
        get :index, { search: 'Joe' }

        expect(assigns(:users).to_a).to eq([@user])
        expect(assigns(:users).to_a).to_not include(@some_other_user)
      end

      it "returns correct users when filtered by roles" do
        get :index, { filter_by_roles: @role.id }

        expect(assigns(:users).to_a).to eq([@user])
        expect(assigns(:users).to_a).to_not include(@some_other_user)
      end

      it "returns correct users when filtered by subjects" do
        get :index, { filter_by_subjects: @subject.id }

        expect(assigns(:users).to_a).to eq([@user])
        expect(assigns(:users).to_a).to_not include(@some_other_user)
      end

      it "returns correct users when filtered by roles and subjects" do
        get :index, { filter_by_subjects: @subject.id, filter_by_roles: @role.id }

        expect(assigns(:users).to_a).to eq([@user])
        expect(assigns(:users).to_a).to_not include(@some_other_user)
      end

      it "returns correct users when filtered by roles, subjects and search term" do
        get :index, { filter_by_roles: @role.id, filter_by_subjects: @subject.id, search: 'Joe' }

        expect(assigns(:users).to_a).to eq([@user])
        expect(assigns(:users).to_a).to_not include(@some_other_user)
      end
    end
  end

  # describe :update do
  #   it 'should update a user\'s attributes' do
  #     put :update, id: @user.id, user: { name: 'Joe User' }

  #     expect(@user.reload.first_name).to eq("Joe")
  #     expect(@user.reload.last_name).to eq("User")
  #   end
  # end

  describe :destroy do
    it "removes a user\'s friendships and deletes their account" do
      @user.invite @some_other_user
      @some_other_user.approve @user

      expect(@some_other_user.reload.friends).to include(@user)
      expect{ delete :destroy, id: @user.id }.to change(User, :count).by(-1)
      expect(@some_other_user.reload.friends).to_not include(@user)
    end
  end


  describe :add_avatar do
    pending 'allows a user to upload profile pic' do
    end
  end

  describe :add_resume do
    pending 'allows a user to upload a resume' do
    end
  end

  describe :remove_resume do
    pending 'allows a user to remove their resume' do
    end
  end
end
