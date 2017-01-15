class CreateMoneyTransaction < ActiveRecord::Migration[5.0]
  def change
    create_table :money_transactions do |t|
      t.integer  :withdrawal_id, null: false
      t.integer  :donation_id, null: false
      t.integer  :status, null: false, default: 1
      t.decimal  :amount, precision: 17, scale: 4
      t.text     :proof_of_payment

      t.timestamps null: false
    end
  end
end
