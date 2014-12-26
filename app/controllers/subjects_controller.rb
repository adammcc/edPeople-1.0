class SubjectsController < ApplicationController

  def create
    @user = current_user
    subject = Subject.find(params[:subject][:id])
    @user.subjects << subject
    @subjects = Subject.all
  end

  def destroy
    @user = current_user
    @subject = Subject.find(params[:id])
    @user.subjects.delete(@subject)

    render nothing: true
  end
end
