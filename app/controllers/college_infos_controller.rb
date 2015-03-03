class CollegeInfosController < ApplicationController

  def edit
    @college_info = CollegeInfo.find(params[:id])
  end

  def update
    @user = current_user
    @college_info = CollegeInfo.find(params[:id])

    if @college_info.college.name == params[:college_info][:name]
      if @college_info.update_attributes(params[:college_info])
        flash[:notice] =  "Saved!"
      else
        flash[:alert] =  "Error!"
      end
    else
      college = College.where(name: params[:college_info][:name]).first
      if college.nil?
        college = College.create(name: params[:college_info][:name])
        @college_info.delete
      end
      college_info = params[:college_info]
      college_info.delete(:name)
      if @college_info = college.college_infos.create(college_info.merge user: @user)
        flash[:notice] =  "Saved!"
      else
        flash[:alert] =  "Error!"
      end
    end

    @colleges = College.all
  end

  def destroy
    @college_info = CollegeInfo.find(params[:id])
    @college_info.destroy

    render nothing: true
  end
end