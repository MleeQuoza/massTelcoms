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

class MoneyRequest < ApplicationRecord
  enum status: { pending: 1, completed: 2, rejected: 3, expired: 4, blocked: 5 }
  
  def requires_transaction
    !self.compounded && self.type != 'Wallet' && self.type != 'ReferralWallet'
  end
  
  def adjust_balance(next_balance)
    self.update!(balance: next_balance)
  end

  def request_completed?
    return false if self.balance > 0
    
    self.money_transactions.present? &&
      self.money_transactions.where("status = #{MoneyTransaction.statuses[:pending]} OR status = #{MoneyTransaction.statuses[:rejected]}").count == 0
  end

  def pending?
    MoneyTransaction.statuses[self.status] == MoneyTransaction.statuses[:pending]
  end
  
  def blocked?
    MoneyTransaction.statuses[self.status] == MoneyTransaction.statuses[:blocked]
  end
  
  def rejected?
    MoneyTransaction.statuses[self.status] == MoneyTransaction.statuses[:rejected]
  end

  def to_s
    "#{id}: Amount: #{amount} Balance: #{balance} User: #{user.name}"
  end
end
