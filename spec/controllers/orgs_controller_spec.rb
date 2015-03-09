require 'spec_helper'

describe OrgsController do
  before(:each) do
    @org_user = FactoryGirl.create(:user, as_org: true)
    org_1 =  FactoryGirl.create(:org, name: 'Test Org', borough: 'Bronx')
    org_1.user = @org_user
    @some_other_org_user = FactoryGirl.create(:user, as_org: true)
    org_2 = FactoryGirl.create(:org, name: 'Queens Org', borough: 'Queens')
    org_2.user = @some_other_org_user
    sign_in @org_user
  end

  describe :show do
    it "renders an org\'s profile" do
      get :show, id: @org_user.id

      expect(response).to render_template(:show)
    end
  end

  describe :index do
    it "returns all org users" do
      get :index

      expect(response).to render_template(:index)
      expect(assigns(:orgs).to_a).to include(@org_user)
      expect(assigns(:orgs).to_a).to include(@some_other_org_user)
    end

    context 'when searching and filtering' do

      it "returns correct orgs when a search term is entered" do
        get :index, { search: 'Queens' }

        expect(assigns(:orgs).to_a).to include(@some_other_org_user)
        expect(assigns(:orgs).to_a).to_not include(@org_user)
      end

      it "returns correct orgs when filtered by locations" do
        get :index, { filter_by_locations: ['Bronx'] }

        expect(assigns(:orgs).to_a).to eq([@org_user])
        expect(assigns(:orgs).to_a).to_not include(@some_other_org_user)
      end

      it "returns correct orgs when filtered by locations and search term" do
        get :index, { filter_by_locarions: ['Bronx'], search: 'Test' }

        expect(response).to render_template(:index)
        expect(assigns(:orgs).to_a).to include(@org_user)
        expect(assigns(:orgs).to_a).to_not include(@some_other_org_user)
      end
    end
  end

end
