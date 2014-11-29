class ExperiencesController < ApplicationController

	def create
		@user = current_user
    experience = @user.experiences.create(params[:experience])
	end

  def edit
    @experience = Experience.find(params[:id])
  end

  def update
    @user = current_user
    @experience = Experience.find(params[:id])
    @experience.update_attributes(params[:experience])
  end

  def destroy
    @experience = Experience.find(params[:id])
    @experience.destroy
  end
end
