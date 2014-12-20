class RolesController < ApplicationController

  def create
    @user = current_user
    role = Role.find(params[:role][:id])
    @user.roles << role
    @roles = Role.all
  end

  def destroy
    @user = current_user
    @role = Role.find(params[:id])
    @user.roles.delete(@role)
  end
end
