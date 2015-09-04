class CertsController < ApplicationController

  def create
    @user = current_user
    if cert = @user.certs.create(params[:cert])
      flash[:notice] =  "Saved!"
    else
      flash[:alert] =  "Error!"
    end
  end

  def destroy
    @cert = Cert.find(params[:id])
    @cert.destroy

    render nothing: true
  end
end
