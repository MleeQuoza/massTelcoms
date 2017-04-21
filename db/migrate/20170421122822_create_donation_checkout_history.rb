class CreateDonationCheckoutHistory < ActiveRecord::Migration[5.0]
  def change
    create_table :donation_checkout_histories do |t|
      t.integer :donation_id
      t.decimal :amount, precision: 17, scale: 4
      
      t.timestamps
    end
  end
end
