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

class MoneyRequest < ActiveRecord::Base
  enum status: { pending: 1, completed: 2, rejected: 3, expired: 4, blocked: 5 }

  after_commit on:[:create] do
    make_money_transactions
  end

  def make_money_transactions
    MoneyTransactionService.new(self).call if self.requires_transaction
  end

  def requires_transaction
    !%w('ReferralWallet', 'Wallet').include? self.type && !self.compounded
  end
end
