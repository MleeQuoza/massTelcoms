class MoneyTransactionsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @donations = current_user.donations
    @withdrawals = current_user.withdrawals
  end
  
  def update_transaction_status
    mt = MoneyTransaction.find(transaction_params[:id])
    mt.update!(status: MoneyTransaction.statuses[transaction_params[:status]])
    redirect_to dashboard_index_path, flash[:notice] => 'Transaction Updated'
  end
end