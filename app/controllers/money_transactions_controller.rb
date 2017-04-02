class MoneyTransactionsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @donations = current_user.non_compounded_donations
    @withdrawals = current_user.pending_withdrawals
    respond_to do |format|
      format.js { render 'index' }
      format.html { render 'money_transactions/index' }
    end
  end
  
  def edit
    @money_transaction = MoneyTransaction.find(params[:id])
  end
  
  def update
    @money_transaction = MoneyTransaction.find(params[:id])
    if @money_transaction.update!(update_params)
      redirect_to money_transactions_path
    else
      render 'edit'
    end
  end
  
  def toggle_transaction_status
    mt = MoneyTransaction.find(params[:id])
    mt.update!(status: params[:status].to_i)
    redirect_to money_transactions_path, flash[:notice] => 'Transaction Updated'
  end
  
  private
  
  def update_params
    params.require(:money_transaction).permit(:proof_of_payment)
  end
end