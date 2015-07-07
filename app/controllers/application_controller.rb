class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :update_sanitized_params, if: :devise_controller?
  before_filter :mailer_set_url_options

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :email, :password, :as_org, :added_password)}
  end

  def after_sign_in_path_for(resource)
    if resource.as_org
      org_path(resource)
    else
      user_path(resource)
    end
  end

  private

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
end
