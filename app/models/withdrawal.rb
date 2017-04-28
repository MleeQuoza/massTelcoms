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
#  donation_id      :integer
#

class Withdrawal < MoneyRequest
  validates :user_id, presence: true
  validates :amount, presence: true
  validates_numericality_of :amount, greater_than: 0
  validate :payment_details_provided

  belongs_to :user
  has_many :money_transactions

  after_commit on: [:create] do
    make_money_transactions
  end

  def make_money_transactions
    return unless self.requires_transaction
    MoneyTransactionService.new(self).match_with_donations
  end
  
  def pending_money_transactions
    self.money_transactions.where(status: [MoneyTransaction.statuses[:pending], MoneyTransaction.statuses[:rejected]])
  end
  
  def payment_details_provided
    if user.payment_account.blank? || user.payment_account.account_number.blank?
      errors.add(:payment_account, 'required for withdrawal')
    end
  end

  def self.unmatched
    Withdrawal.where('balance > 0 and status = 1').to_a
  end
  
  def self.unmatched_total
    Withdrawal.unmatched.map(&:balance).sum
  end
end
