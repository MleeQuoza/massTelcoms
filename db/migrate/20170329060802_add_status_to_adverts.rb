class AddStatusToAdverts < ActiveRecord::Migration[5.0]
  def change
    add_column :adverts, :status, :text, null: false
  end
end
