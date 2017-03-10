class PaymentAccountsController < ApplicationController
  before_action :authenticate_user!

  def new
    @account = PaymentAccount.new
  end

  def create
    account = PaymentAccount.create(account_params)
    if account.save!
      redirect_to edit_payment_account_path(account.id), notice: 'Payment Account saved'
    end
  end

  def edit
    @account = current_user.payment_account
  end

  def update
    account = PaymentAccount.find(params[:id])
    if account.update!(account_params)
      redirect_to edit_payment_account_path(account.id), notice: 'Updated successfully'
    end
  end

  def destroy
    account = PaymentAccount.find(params[:id])
    if account.destroy!
      redirect_to dashboard_index_path, notice: 'Successfully Deleted'
    end
  end

  private
  def account_params
    params.require(:payment_account).permit(:user_id, :account_holder_name, :bank_name, :branch_code, :account_number, :account_type)
  end
end