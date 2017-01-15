class MoneyTransactionsController < ApplicationController
  before_action :authenticate_user!

  def complete_transaction
    mt = MoneyTransaction.find(params[:id])
    mt.update!(status: MoneyTransaction.statuses[:completed])
    redirect_to dashboard_index_path, flash[:notice] => 'Transaction Marked Complete'
  end

  def reject_transaction
    mt = MoneyTransaction.find(params[:id])
    mt.update!(status: MoneyTransaction.statuses[:rejected])
    redirect_to dashboard_index_path, flash[:notice] => 'Transaction Marked Rejected'
  end
end