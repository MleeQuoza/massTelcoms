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

class MoneyRequest < ActiveRecord::Base
  enum status: { pending: 1, completed: 2, rejected: 3, expired: 4, blocked: 5 }

  after_commit on:[:create] do
    make_money_transactions
  end

  def make_money_transactions
    return unless self.requires_transaction
    MoneyTransactionService.new(self).call
  end

  def requires_transaction
    !self.compounded && self.type != 'Wallet' && self.type != 'ReferralWallet'
  end
  
  def adjust_balance(next_balance)
    self.update(balance: next_balance)
  end
end
