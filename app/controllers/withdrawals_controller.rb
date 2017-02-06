class WithdrawalsController < ApplicationController
  before_action :authenticate_user!

  def new
    @withdrawal = Withdrawal.new
  end

  def create
    withdrawal = MoneyRequestService.new(withdrawals_params, {type: Withdrawal.name }).call

    if withdrawal.save!
      redirect_to dashboard_index_path, flash[:notice] => 'withdrawal Request Successful'
    else
      render 'new'
    end
  end

  def user_withdrawals
    @withdrawals = Withdrawal.order(:created_at).where(user_id: params[:user_id])
  end


  private

  def withdrawals_params
    params.require(:withdrawal).permit(:user_id, :amount)
  end
end
