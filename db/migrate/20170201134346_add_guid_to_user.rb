class AddGuidToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :guid, :text, null: false
  end
end
