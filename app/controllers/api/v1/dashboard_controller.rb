class Api::V1::DashboardController < Api::V1::BaseController
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
    @all_transactions = MoneyTransaction.all
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

  def filter_money_transactions
    f = filter_params
    @all_transactions = MoneyTransaction.where("created_at >= '#{(Time.parse(f[:from]))}' AND created_at <= '#{(Time.parse(f[:to]))}'")
    render 'dashboard/money_transactions'
  end
  
  private
  
  def filter_params
    params.require(:transaction_filter).permit(:from, :to)
  end
end
