# == Schema Information
#
# Table name: donation_checkout_histories
#
#  id          :integer          not null, primary key
#  donation_id :integer
#  amount      :decimal(17, 4)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class DonationCheckoutHistory < ApplicationRecord
  belongs_to :donation
end
