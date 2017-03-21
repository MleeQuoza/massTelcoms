FactoryGirl.define do
  factory :referral do
    #don't know how to create multiple users for this
    sequence(:referee_id){ |e| e }
    sequence(:referrer_id){ |e| e }
  end
end