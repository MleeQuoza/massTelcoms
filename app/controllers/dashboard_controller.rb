class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.is?('admin')
      @money_transactions = MoneyTransaction.where(status: 3)
      @adverts = Advert.all
      render 'dashboard/admin'
    else
      render 'dashboard/index'
    end
  end
  
  def money_transactions
    @all_transactions = MoneyTransaction.all
    @unmatched_donations = Donation.unmatched
    @unmatched_withdrawals = Withdrawal.unmatched
  end
  
  def users
    @active_users = User.active_users
    @inactive_users = User.inactive_users
  end
  
  def profile
    @payment_account = current_user.bank_account
  end
  
  def admin
    @money_transactions = MoneyTransaction.where(status: 3)
    @adverts = Advert.all
    render 'dashboard/admin'
  end
  
  def testing
    @donations = current_user.donations
    @withdrawals = current_user.withdrawals
  end

  def filter_money_transactions
    f = filter_params
    if Time.valid_date_string?(f[:from]) && Time.valid_date_string?(f[:to])
      @all_transactions = MoneyTransaction.where("created_at >= '#{(Time.parse(f[:from]))}' AND created_at <= '#{(Time.parse(f[:to]))}'")
    else
      @all_transactions = MoneyTransaction.all
    end
    render 'dashboard/money_transactions'
  end
  
  private
  
  def filter_params
    params.permit(:from, :to)
  end
end
