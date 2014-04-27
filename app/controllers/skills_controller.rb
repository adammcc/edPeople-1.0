class SkillsController < ApplicationController
  def new
  end

  def create
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
