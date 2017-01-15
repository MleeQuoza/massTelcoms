# == Schema Information
#
# Table name: money_requests
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null
#  type          :text
#  amount        :decimal(17, 4)
#  balance       :decimal(17, 4)
#  status        :integer          default("1"), not null
#  maturity_date :date
#  matured       :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  compounded    :boolean          default("false")
#

class Wallet < MoneyRequest
  belongs_to :user
end
