# == Schema Information
#
# Table name: payment_accounts
#
#  id                  :integer          not null, primary key
#  user_id             :integer          not null
#  bank_name           :text
#  account_number      :text
#  branch_code         :text
#  account_type        :text
#  account_holder_name :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :payment_account do
    user
    bank_name 'FNB'
    account_number '123456789'
    branch_code '09876'
    account_type 'Savings'
    account_holder_name 'Holder Name'
  end
end

