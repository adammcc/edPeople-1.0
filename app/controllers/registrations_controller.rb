class RegistrationsController < Devise::RegistrationsController


  def create
    super

    if params[:user][:as_org]
      resource.create_org(name: params[:org][:name], first_name: 'org_first', last_name: 'org_last')
      resource.save
    end
  end

  def after_sign_up_path_for(resource)
    if resource.as_org
      org_path(resource)
    else
      user_path(resource)
    end
  end

end