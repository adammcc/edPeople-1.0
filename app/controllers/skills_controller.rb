class SkillsController < ApplicationController

  def create
    @user = current_user
    skill = @user.skills.create(params[:skill])

    redirect_to :back
  end

  def destroy
  	@skill = Skill.find(params[:id])
    @skill.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user) }
      format.json { head :no_content }
    end
  end
end
