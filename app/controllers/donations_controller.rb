class DonationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @donation = Donation.new
  end

  def create
    @donation = MoneyRequestService.new(donation_params, { type: Donation.name }).call

    if @donation.save!
      redirect_to dashboard_index_path, flash[:notice] => 'Donation Successful'
    else
      render 'new'
    end
  end

  def user_donations
    @donations = Donation.where(user_id: params[:user_id])
  end

  def donate_profit

  end


  private

  def donation_params
    params.require(:donation).permit(:user_id, :amount)
  end
end
