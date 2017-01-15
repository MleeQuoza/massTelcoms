class CreatePaymentAccount < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_accounts do |t|
      t.integer :user_id, null: false

      t.text  :bank_name
      t.text  :account_number
      t.text  :branch_code
      t.text  :account_type
      t.text  :account_holder_name

      t.timestamps null: false
    end
  end
end
