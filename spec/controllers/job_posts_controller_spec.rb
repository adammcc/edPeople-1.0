require 'spec_helper'

describe JobPostsController do
  before(:each) do
    @user = FactoryGirl.create(:user, first_name: 'Joe', last_name: 'User' )
    @job_post = FactoryGirl.create(:job_post, title: 'Some job')
    @job_post_2 = FactoryGirl.create(:job_post, title: 'Some other job')
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