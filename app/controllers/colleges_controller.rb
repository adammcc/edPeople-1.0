class CollegesController < ApplicationController

  def create
    @user = current_user
    @colleges = College.all
    college = College.where(name: params[:college][:name]).first
    if college.nil?
      college = College.create(name: params[:college][:name])
    end
    college_info = params[:college]
    college_info.delete(:name)
    college.college_infos.create(college_info.merge user: @user)
  end
end
