class DonationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @donation = Donation.new
  end

  def create
    if donation_params[:compounded]
      
      Donation.transaction do
        donation = Donation.find(donation_params[:donation_id])
        donation.profit_from_date = Time.zone.now
        
        compounded_donation = MoneyRequestService.new(donation_params, { type: Donation.name }).call
        compounded_donation.maturity_date = Time.zone.now + 6.months
        compounded_donation.profit_from_date = Time.zone.now
        compounded_donation.save!
        
        donation.save!
      end
      redirect_to user_donations_path(user_id: current_user.id), notice: 'Donation Successful'
    else
      donation = MoneyRequestService.new(donation_params, { type: Donation.name }).call
  
      donation.save!
      redirect_to user_donations_path(user_id: current_user.id), notice: 'Donation Successful'
    end
  end

  def user_donations
    @donations = Donation.order(:created_at).where(user_id: params[:user_id])
  end

  private

  def donation_params
    params.permit(:user_id, :amount, :compounded, :donation_id)
  end
end
