class DonationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @donation = Donation.new

    respond_to do |format|
      format.html{ @donation }
      format.js { @donation }
    end
  end

  def create
    @donation = MoneyRequestService.new(donation_params, { type: Donation.name }).call

    respond_to do |format|
      if @donation.save!
        format.html { redirect_to dashboard_index_path, notice: 'Donation Successful' }
        format.json { redirect_to dashboard_index_path, notice: 'Donation Successful' }
      else
        format.html { render 'new'}
        format.json { render json: @donation.errors.full_messages, status: :unprocessable_entity }
      end
    end

  end

  def user_donations
    @donations = Donation.where(user_id: params[:user_id])
  end

  def donate_profit
  end


  private

  def donation_params
    params.permit(:user_id, :amount)
  end
end
