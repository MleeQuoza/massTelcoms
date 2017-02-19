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

class Referral< ActiveRecord::Base
  belongs_to :user
end
