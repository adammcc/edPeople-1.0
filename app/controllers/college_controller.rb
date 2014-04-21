class CollegeController < ApplicationController

	def new
  end

	def edit
    @college = College.find(params[:id])
  end

  def update
    @college = College.find(params[:id])
    @user = current_user

    @college.users_meta_data[@user.id.to_s] = {start_date: params[:college][:start_date], 
                                              end_date: params[:college][:end_date], 
                                              degree_type: params[:college][:degree_type], 
                                              major: params[:college][:major]
                                            }
    @college.save

    respond_to do |format|
      if @college.update_attributes(params[:college])
        format.html { redirect_to @user, notice: 'College was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_college
  	@colleges = College.all
  end

  def do_add_college
  	@college = College.find(params[:college][:name])
    @user = current_user

    @college.users_meta_data[@user.id.to_s] = {start_date: params[:college][:start_date], 
                                              end_date: params[:college][:end_date], 
                                              degree_type: params[:college][:degree_type], 
                                              major: params[:college][:major]
                                            }
    @college.save
    @user.colleges << @college

    redirect_to user_path(@user)
  end
end
