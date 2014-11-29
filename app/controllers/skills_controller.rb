class SkillsController < ApplicationController

  def create
    @user = current_user
    skill = @user.skills.create(params[:skill])
  end

  def destroy
  	@skill = Skill.find(params[:id])
    @skill.destroy
  end
end
