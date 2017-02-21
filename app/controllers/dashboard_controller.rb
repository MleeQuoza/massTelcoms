class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.is?('admin')
      render 'dashboard/admin'
    else
      render 'dashboard/index'
    end
  end
  
  def profile
    @payment_account = current_user.bank_account
  end
  
  def admin
  end
end
