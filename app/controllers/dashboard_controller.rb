class DashboardController < ApplicationController
  before_action :authenticate_user!

  def admin_dash
  end

  def profile
    @payment_account = get_payment_account(current_user)
  end

  private

  def get_payment_account(user)
    if user.payment_accounts.present?
      user.payment_accounts.first
    else
      PaymentAccount.new
    end
  end
end
