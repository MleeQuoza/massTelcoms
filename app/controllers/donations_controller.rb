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
    d_params = donation_params
    respond_to do |format|
      if d_params[:compounded] && d_params[:compounded].to_bool
        
        Donation.transaction do
          compounded_donation = MoneyRequestService.new(d_params, { type: Donation.name }).call
          compounded_donation.maturity_date = Time.zone.now + 6.months
          compounded_donation.profit_from_date = Time.zone.now
          compounded_donation.compounded = true
          compounded_donation.save!

          donation = Donation.find(d_params[:donation_id]) if d_params[:donation_id].present?
          
          if donation.present?
            donation.profit_from_date = Time.zone.now
            donation.save!
          end
        end
        format.js { render inline: 'location.reload();' }
        format.html { redirect_to user_donations_path(user_id: current_user.id) }
      else
        donation = MoneyRequestService.new(d_params, { type: Donation.name }).call
        donation.save!

        format.js { render inline: 'location.reload();' }
        format.html { redirect_to user_donations_path(user_id: current_user.id) }
      end
    end
  end

  def user_donations
    @donations = Donation.order(:created_at).where(user_id: params[:user_id])
  end

  private

  def donation_params
    params.permit(:user_id, :amount, :compounded, :donation_id)
  end
  
  def donation_update_params
    params.require(:donation).permit(:user_id, :profit_from_date)
  end
end
