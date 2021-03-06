class WalletsController < ApplicationController
  before_action :authenticate_user!
  
  def add_to_wallet
    return unless wallet_params[:amount].to_d > 0
    
    Wallet.transaction do
      donation = Donation.find(wallet_params[:donation_id])
      donation.profit_from_date = Time.zone.today
      
      history = DonationCheckoutHistory.new(donation: donation, amount: wallet_params[:amount].to_d)
      
      user = User.find(wallet_params[:user_id])
      wallet = user.wallet
      wallet.update!(balance: wallet.balance + wallet_params[:amount].to_d)
      
      donation.save!
      history.save!
      wallet.save!
    end
    redirect_to user_donations_path(user_id: current_user.id), notice: 'Checkout Complete'
  end

  def add_bonus_to_wallet
    Wallet.transaction do
      user = User.find(wallet_params[:user_id])
      paying_referrals = user.paying_referrals
      paying_referrals.each{ |pr| pr.update(bonus_paid_out: true)}
      
      wallet = user.wallet
      wallet.update!(balance: wallet.balance + wallet_params[:amount].to_d)
      wallet.save!
    end
    redirect_to dashboard_index_path(user_id: current_user.id), notice: 'Checkout Complete'
  end
  
  def withdraw_from_wallet
    Withdrawal.transaction do
      withdrawal = Withdrawal.new
      wallet = current_user.wallet
      withdrawal.user_id = current_user.id
      withdrawal.amount = wallet.balance
      withdrawal.balance = wallet.balance
      
      if withdrawal.save!
        wallet.update(amount: 0, balance: 0)
        wallet.save!
      end
    end
    
    redirect_to user_withdrawals_path(user_id: current_user.id)
  end
  
  def fund_wallet
    amount = wallet_params[:amount]
    user = User.find_by_email(wallet_params[:email])
    if user
      user.wallet.update!(balance: amount, amount: amount)
    end
    redirect_to dashboard_index_path, notice: "#{amount} Added to wallet"
  end
  
  private
  
  def wallet_params
    params.permit(:user_id, :amount, :donation_id, :email)
  end
end