class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.is?('admin')
      @money_transactions = MoneyTransaction.where(status: 3)
      render 'dashboard/admin'
    else
      render 'dashboard/index'
    end
  end
  
  def money_transactions
  end
  
  def profile
    @payment_account = current_user.bank_account
  end
  
  def admin
  end
  
  def testing
    @donations = current_user.donations
    @withdrawals = current_user.withdrawals
  end
end
