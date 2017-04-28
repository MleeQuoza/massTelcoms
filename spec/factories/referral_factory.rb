# == Schema Information
#
# Table name: referrals
#
#  id             :integer          not null, primary key
#  referrer_id    :integer          not null
#  referee_id     :integer          not null
#  bonus_paid_out :boolean          default(FALSE), not null
#  bonus_amount   :decimal(17, 4)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :referral do
    #don't know how to create multiple users for this
    sequence(:referee_id){ |e| e }
    sequence(:referrer_id){ |e| e }
  end
end
