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