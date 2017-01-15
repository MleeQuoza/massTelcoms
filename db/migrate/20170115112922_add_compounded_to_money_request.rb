class AddCompoundedToMoneyRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :money_requests, :compounded, :boolean, default: false
  end
end
