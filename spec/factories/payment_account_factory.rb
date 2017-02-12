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

