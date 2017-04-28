# == Schema Information
#
# Table name: money_transactions
#
#  id               :integer          not null, primary key
#  withdrawal_id    :integer          not null
#  donation_id      :integer          not null
#  status           :integer          default("pending"), not null
#  amount           :decimal(17, 4)
#  proof_of_payment :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :money_transaction do
    withdrawal
    donation
    amount 2000
  end
end
