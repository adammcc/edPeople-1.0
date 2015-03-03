class ExperiencesController < ApplicationController

	def create
		@user = current_user
    if experience = @user.experiences.create(params[:experience])
      flash[:notice] =  "Saved!"
    else
      flash[:alert] =  "Error!"
    end
	end

  def edit
    @experience = Experience.find(params[:id])
  end

  def update
    @user = current_user
    @experience = Experience.find(params[:id])
    if @experience.update_attributes(params[:experience])
      flash[:notice] =  "Saved!"
    else
      flash[:alert] =  "Error!"
    end
  end

  def destroy
    @experience = Experience.find(params[:id])
    @experience.destroy

    render nothing: true
  end
end
