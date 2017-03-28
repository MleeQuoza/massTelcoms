class Api::V1::MoneyTransactionsController < Api::V1::BaseController
  before_action :authenticate_user!
  
  def index
    @donations = current_user.non_compounded_donations
    @withdrawals = current_user.pending_withdrawals
  end
  
  def toggle_transaction_status
    mt = MoneyTransaction.find(params[:id])
    mt.update!(status: params[:status].to_i)
    redirect_to money_transactions_path, flash[:notice] => 'Transaction Updated'
  end
end