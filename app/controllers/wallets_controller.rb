class WalletsController < ApplicationController
  
  def add_to_wallet
    Wallet.transaction do
      donation = Donation.find(wallet_params[:donation_id])
      donation.profit_from_date = Time.zone.now
      
      user = User.find(wallet_params[:user_id])
      wallet = user.wallet
      wallet.update!(amount: wallet.amount + wallet_params[:amount].to_d)
      
      donation.save!
      wallet.save!
    end
    redirect_to user_donations_path(user_id: current_user.id), notice: 'Checkout Complete'
  end
  
  def withdraw_from_wallet
    Withdrawal.transaction do
      withdrawal = Withdrawal.new
      wallet = current_user.wallet
      withdrawal.user_id = current_user.id
      withdrawal.amount = wallet.amount
      withdrawal.balance = wallet.amount
      
      withdrawal.save!
      
      wallet.update(amount: 0)
      wallet.save!
    end
    
    redirect_to user_withdrawals_path(user_id: current_user.id)
  end
  
  private
  
  def wallet_params
    params.permit(:user_id, :amount, :donation_id)
  end
end