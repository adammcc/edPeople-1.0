require 'spec_helper'

describe JobPostsController do
  before(:each) do
    @user = FactoryGirl.create(:user, first_name: 'Joe', last_name: 'User' )
    @job_post = FactoryGirl.create(:job_post, title: 'Art Teacher')
    @job_post_2 = FactoryGirl.create(:job_post, title: 'Math Teacher')
    sign_in @user
  end

  describe :show do
    it "renders a jobs post\'s show page" do
      get :show, id: @job_post.id

      expect(response).to render_template(:show)
    end
  end

  describe :index do
    it "returns all jobs" do
      get :index

      expect(response).to render_template(:index)
      expect(assigns(:jobs).to_a).to include(@job_post)
      expect(assigns(:jobs).to_a).to include(@job_post_2)
    end

    context 'when searching and filtering' do
      before(:each) do
        @location = FactoryGirl.create(:location, name: 'Bronx')
        @role = FactoryGirl.create(:role, name: 'Teacher')
        @job_post.role = @role
        @job_post.location = @location
        @job_post.save
      end

      it "returns correct jobs when a search term is entered" do
        get :index, { search: 'Art' }

        expect(assigns(:jobs).to_a).to eq([@job_post])
        expect(assigns(:jobs).to_a).to_not include(@job_post_2)
      end

      it "returns correct jobs when filtered by role" do
        get :index, { filter_by_roles: [@role.id] }

        expect(assigns(:jobs).to_a).to eq([@job_post])
        expect(assigns(:jobs).to_a).to_not include(@job_post_2)
      end

      it "returns correct jobs when filtered by locations" do
        get :index, { filter_by_locations: [@location.id] }

        expect(assigns(:jobs).to_a).to eq([@job_post])
        expect(assigns(:jobs).to_a).to_not include(@job_post_2)
      end

      it "returns correct jobs when filtered by roles and locations" do
        get :index, { filter_by_locations: [@location.id], filter_by_roles: [@role.id] }

        expect(assigns(:jobs).to_a).to eq([@job_post])
        expect(assigns(:jobs).to_a).to_not include(@job_post_2)
      end

      it "returns correct jobs when filtered by roles, locations and search term" do
        get :index, { filter_by_roles: [@role.id], filter_by_locations: [@location.id], search: 'Art' }

        expect(assigns(:jobs).to_a).to eq([@job_post])
        expect(assigns(:jobs).to_a).to_not include(@job_post_2)
      end
    end
  end

  describe :create do
    it 'creates a new job post' do
      expect{ post :create,
        job_post: {
          title: 'Some New Job Post',
          organization: 'Some Org',
          location: 'Bronx, Ny',
          neighborhood: 'Hunts Point',
          contact_info: 'Org@test.com',
          description: 'This is a test'
        },
        format: :js
      }.to change(JobPost, :count).by(1)
    end
  end

  describe :update do
    it 'updates a job post' do
      put :update, id: @job_post.id, job_post: {title: 'New Title'}, format: :js

      expect(@job_post.reload.title).to eq('New Title')
    end
  end

  describe :destroy do
    it 'deletes a job post' do
      expect{ delete :destroy, id: @job_post.id, format: :js }.to change(JobPost, :count).by(-1)
    end
  end
end