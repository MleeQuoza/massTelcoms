class RenameRefererIdToRefererGuid < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :referer_id, :integer
    add_column :users, :referer_guid, :text
  end
end
