class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_announcements
  
  def load_announcements
    @all_announcements = ::Announcement.all
  end

  def after_sign_in_path_for(user)
    if user.is_a?(::AdminUser)
      admin_dashboard_path(user)
    else
      assign_pending_money_requests(user)
      load_announcements
      user.payment_account.present? ? money_transactions_path : new_payment_account_path
    end
  end

  def after_sign_out_path_for(user)
    new_user_session_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :cellphone, :referer_guid, :referrer_email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :cellphone])
  end

  private
  def assign_pending_money_requests(user)
    donations = user.donations.where("balance > 0 AND status = #{MoneyRequest.statuses[:pending]}")
    donations.each do |donation|
      MoneyTransactionService.new(donation).match_with_withdrawals
    end

    withdrawals = user.withdrawals.where("balance > 0 AND status = #{MoneyRequest.statuses[:pending]}")
    withdrawals.each do |withdrawal|
      MoneyTransactionService.new(withdrawal).match_with_donations
    end
  end
end
