ActiveAdmin.register User do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  
  index do
    id_column
    column :first_name
    column :last_name
    column :email
    column :cellphone
    column :guid
    column :roles_mask
    column :referer_guid
    column :referrer_email
    column :last_sign_in_at
    actions
  end
  
  filter :first_name
  filter :last_name
  filter :email
  filter :cellphone
end
