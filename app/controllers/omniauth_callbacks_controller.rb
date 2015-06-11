class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def linkedin
	  auth = request.env["omniauth.auth"]
	  @user = User.connect_to_linkedin(auth, current_user)
	  if @user.persisted?
	  	if user_signed_in?
	  		flash[:notice] = I18n.t "devise.omniauth_callbacks.sync_success"
	  	else
	    	flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
	    end
	    sign_in_and_redirect @user, :event => :authentication
	  else
	    session["devise.linkedin_uid"] = request.env["omniauth.auth"]
	    redirect_to new_user_registration_url
	  end
	end
end