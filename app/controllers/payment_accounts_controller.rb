class PaymentAccountsController < ApplicationController
  before_action :authenticate_user!

  def new
    @account = PaymentAccount.new
  end

  def create
    account = PaymentAccount.create(account_params)
    if account.save!
      redirect_to dashboard_index_path, flash[:notice] => 'Payment Account saved'
    end
  end

  def edit
    @account = PaymentAccount.find(params[:id])
  end

  def update
    account = PaymentAccount.find(params[:id])
    if account.update!(account_params)
      redirect_to dashboard_index_path, flash[:notice] => 'Updated successfully'
    end
  end

  def destroy
    account = PaymentAccount.find(params[:id])
    if account.destroy!
      redirect_to dashboard_index_path, flash[:notice] => 'Successfully Deleted'
    end
  end

  private
  def account_params
    params.require(:payment_account).permit(:user_id, :account_holder_name, :bank_name, :branch_code, :account_number)
  end
end