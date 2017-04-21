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

class PaymentAccount < ApplicationRecord
  belongs_to :user
end
