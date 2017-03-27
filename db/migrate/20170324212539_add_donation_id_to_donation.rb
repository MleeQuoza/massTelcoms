class AddDonationIdToDonation < ActiveRecord::Migration[5.0]
  def change
    add_column :money_requests, :donation_id, :integer
  end
end
