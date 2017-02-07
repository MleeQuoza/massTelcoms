class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def profile
    @payment_account = current_user.bank_account
  end
end
