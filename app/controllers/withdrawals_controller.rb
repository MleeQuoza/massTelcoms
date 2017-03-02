class WithdrawalsController < ApplicationController
  before_action :authenticate_user!

  def new
    @withdrawal = Withdrawal.new
  end

  def create
    respond_to do |format|
      withdrawal = MoneyRequestService.new(withdrawals_params, {type: Withdrawal.name }).call
      
      if withdrawal.save!
        current_user.wallet.update!(amount: (current_user.wallet.amount - withdrawal.amount))
        format.js { render inline: 'location.reload();' }
        format.html { redirect_to dashboard_index_path, flash[:notice] => 'withdrawal Request Successful' }
      else
        format.js { render inline: 'location.reload();' }
        format.html { render 'new' }
      end
    
    end
  end

  def user_withdrawals
    @withdrawals = Withdrawal.order(:created_at).where(user_id: params[:user_id])
  end


  private

  def withdrawals_params
    params.permit(:user_id, :amount)
  end
end
