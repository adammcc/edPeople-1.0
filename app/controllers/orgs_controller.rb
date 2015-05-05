class OrgsController < ApplicationController

  before_filter :authenticate_user!, except: [:index, :show]

  def index
    @search_term = params[:search]
    @locations = Location.all.asc(:name)

    locations = params[:filter_by_locations]

    if locations
      @orgs = User.just_orgs
    else
      @orgs = User.just_orgs.sort_by{rand}.paginate(page: params[:page], per_page: 10)
    end

    if @search_term.present? || locations
      @orgs = User.just_orgs.full_text_search(@search_term) if @search_term.present?

      if locations
        real_orgs = Org.in(borough: locations)
        @orgs = @orgs.in(org_id: real_orgs.map { |org| org.id.to_s })
      end
      @orgs = @orgs.paginate(page: params[:page], per_page: 10)
    end
  end

  def show
    if params[:id]
      @org_user = User.find params[:id]
      @org = @org_user.org
    else
      @org_user = current_user
      @org = current_user.org
    end
    @suggestions = User.where(as_org: true).shuffle.first(3)
  end

  def update
    @org = Org.find(params[:id])
    @org.update_attributes(params[:org])

    if params[:address_update]
      redirect_to user_path(@org.user)
    else
      render nothing: true
    end
  end

  private

end
