class ExperiencesController < ApplicationController

	def create
		@user = current_user
    experience = @user.experiences.create(params[:experience])

    redirect_to :back
	end

  def edit
    @experience = Experience.find(params[:id])
  end

  def update
    @experience = Experience.find(params[:id])
    @experience.update_attributes(params[:experience])

    redirect_to user_path(current_user)
  end

  def destroy
    @experience = Experience.find(params[:id])
    @experience.destroy

    redirect_to user_path(current_user)
  end
end
