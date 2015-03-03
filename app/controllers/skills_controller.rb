class SkillsController < ApplicationController

  def create
    @user = current_user
    if skill = @user.skills.create(params[:skill])
      flash[:notice] =  "Saved!"
    else
      flash[:alert] =  "Error!"
    end
  end

  def destroy
  	@skill = Skill.find(params[:id])
    @skill.destroy
  end
end
