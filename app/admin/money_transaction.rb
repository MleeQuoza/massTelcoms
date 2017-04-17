ActiveAdmin.register MoneyTransaction do
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
    column 'Date' do |mt|
      mt.created_at.strftime('%F')
    end

    column 'Receiver', &:withdrawal_user_name
    column 'Donor', &:donation_user_name
    column 'Amount', &:amount
    column 'Status', &:status
  end
  
  filter :withdrawal_user_name
  filter :amount
  
  member_action :reassign, method: :patch do
    resource.update!(status: 'pending')
    redirect_to resource_path, notice: 'Donation reassigned'
  end

  member_action :remove, method: :patch do
    resource.update!(status: 'blocked')
    redirect_to resource_path, notice: 'Donation removed'
  end
end
