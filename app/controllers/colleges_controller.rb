class CollegesController < ApplicationController

  def create
    @user = current_user
    college = College.where(name: params[:college][:name]).first
    if college.nil?
      college = College.create(name: params[:college][:name])
    end
    @user.colleges << college
    college.users_meta_data[@user.id.to_s] = { start_date: params[:college][:start_date],
                                               end_date: params[:college][:end_date],
                                               degree_type: params[:college][:degree_type],
                                               major: params[:college][:major]
                                              }
    college.save
    @colleges = College.all
  end

	def edit
    @college = College.find(params[:id])
  end

  def update
    @college = College.find(params[:id])
    @user = current_user

    @college.users_meta_data[@user.id.to_s] = { start_date: params[:college][:start_date],
                                                end_date: params[:college][:end_date],
                                                degree_type: params[:college][:degree_type],
                                                major: params[:college][:major]
                                              }
    @college.save
  end

  def destroy
    @college = College.find(params[:id])
    @college.destroy
  end
end
