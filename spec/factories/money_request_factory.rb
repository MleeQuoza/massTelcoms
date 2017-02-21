# == Schema Information
#
# Table name: money_requests
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  type             :text
#  amount           :decimal(17, 4)
#  balance          :decimal(17, 4)
#  status           :integer          default("pending"), not null
#  maturity_date    :date
#  matured          :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  compounded       :boolean          default(FALSE)
#  profit_from_date :datetime
#

FactoryGirl.define do
  factory :donation do
    type 'Donation'
    amount 10000
    balance 10000
    user
  end
  
  factory :withdrawal do
    type 'Withdrawal'
    amount 10000
    balance 10000
    user
  end
  
  factory :wallet do
    type 'Wallet'
    amount 20000
    balance 20000
    user
  end
  
  factory :referral_wallet do
    type 'ReferralWallet'
    amount 5000
    balance 5000
    user
  end
end
