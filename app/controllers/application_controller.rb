class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(user)
    user.payment_account.present? ? dashboard_index_path : new_payment_account_path
  end

  def after_sign_out_path_for(user)
    new_user_session_path
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :cellphone, :referer_guid, :referrer_email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :cellphone])
  end
end
