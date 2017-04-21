class AddRolesMaskToAdminUser < ActiveRecord::Migration[5.0]
  def change
    add_column :admin_users, :roles_mask, :integer
  end
end
