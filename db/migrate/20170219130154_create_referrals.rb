class CreateReferrals < ActiveRecord::Migration[5.0]
  def change
    create_table :referrals do |t|
      t.integer :referrer_id, null: false
      t.integer :referee_id, null: false
      t.boolean :bonus_paid_out, null: false, default: false
      t.decimal :bonus_amount, precision: 17, scale: 4
      t.timestamps null: false
    end
  end
end
