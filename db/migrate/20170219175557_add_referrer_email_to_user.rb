class AddReferrerEmailToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :referrer_email, :text
  end
end
