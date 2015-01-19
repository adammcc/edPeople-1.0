class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def linkedin
	  auth = request.env["omniauth.auth"]
	  @user = User.connect_to_linkedin(auth, current_user)
	  if @user.persisted? && @user.has_linkedin_account
	  	flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
	  	sign_in(@user)
	    redirect_to add_password_user_path(@user)
	  elsif @user.persisted?
	    flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
	    sign_in_and_redirect @user, :event => :authentication
	  else
	    session["devise.linkedin_uid"] = request.env["omniauth.auth"]
	    redirect_to new_user_registration_url
	  end
	end
end