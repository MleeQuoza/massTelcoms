class CreateMoneyRequest < ActiveRecord::Migration[5.0]
  def change
    create_table :money_requests do |t|
      t.integer :user_id, null: false
      t.text    :type
      t.decimal :amount, precision: 17, scale: 4
      t.decimal :balance, precision: 17, scale: 4
      t.integer :status, null: false, default: 1
      t.date  :maturity_date
      t.boolean :matured

      t.timestamps null: false
    end
  end
end
