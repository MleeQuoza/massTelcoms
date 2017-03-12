class Api::V1::DonationsController < Api::V1::BaseController
  def index
    respond_with Donation.all
  end
end
