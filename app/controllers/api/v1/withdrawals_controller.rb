class Api::V1::WithdrawalsController < Api::V1::BaseController
  def index
    respond_with Withdrawal.all
  end
end