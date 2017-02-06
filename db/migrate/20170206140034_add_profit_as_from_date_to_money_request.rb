class AddProfitAsFromDateToMoneyRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :money_requests, :profit_from_date, :datetime
  end
end
