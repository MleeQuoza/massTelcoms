class MakeAdvertStatusInteger < ActiveRecord::Migration[5.0]
  def change
    remove_column :adverts, :status, :text
    add_column  :adverts, :status, :integer, null: false, default: 1
  end
end
