class DonationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @donation = Donation.new
  end

  def edit
    @donation = Donation.find(params[:id])
  end
  
  def update
    donation = Donation.find(params[:id])
    if donation.update(donation_update_params)
      redirect_to user_donations_path(user_id: current_user.id)
    else
      render 'edit'
    end
  end
  
  def create
    service = MoneyRequestService.new(donation_params, { type: Donation.name })
    donation = service.call
    respond_to do |format|
      if donation.save
        if donation.compounded
          service.adjust_for_compound
        end
        format.js { render inline: 'location.reload();' }
        format.html { redirect_to user_donations_path(user_id: current_user.id) }
      end
    end
  end

  def user_donations
    @donations = Donation.order(:created_at).where(user_id: params[:user_id], status: MoneyRequest.statuses[:completed])
  end

  private

  def donation_params
    params.permit(:user_id, :amount, :compounded, :donation_id, :status)
  end
  
  def donation_update_params
    params.require(:donation).permit(:user_id, :created_at, :amount)
  end
end
