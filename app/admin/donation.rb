ActiveAdmin.register Donation do
  menu priority: 5
  
  # index title: "All Donations: #{Donation.unmatched_total}" do
  #   column 'Date' do |d|
  #     d.created_at.strftime('%F')
  #   end
  #
  #   column 'Amount', &:amount
  #   column 'Balance', &:balance
  #   column 'User' do |d|
  #     d.user.name
  #   end
  # end
  
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
end
