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

class MoneyTransaction < ActiveRecord::Base
  belongs_to :withdrawal
  belongs_to :donation
  validates_numericality_of :amount, greater_than: 0

  enum status: { pending: 1, completed: 2, rejected: 3, blocked: 4 }
  
  mount_uploader :proof_of_payment, ProofOfPaymentUploader
  
  after_commit on: [:create] do
    adjust_balances
  end
  
  after_commit on: [:update] do
    handle_status_update
  end

  def withdrawal_user_name
    self.withdrawal.user.name
  end

  def donation_user_name
    self.donation.user.name
  end
  
  def recipient_bank_name
    self.withdrawal.user.payment_account&.bank_name
  end

  def recipient_account_type
    self.withdrawal.user.payment_account&.account_type
  end

  def recipient_account_number
    self.withdrawal.user.payment_account&.account_number
  end

  def recipient_branch_code
    self.withdrawal.user.payment_account&.branch_code
  end
  
  def hours_elapsed
    return TimeDifference.between(self.created_at, self.updated_at).in_hours.round(0) unless self.pending?
    
    TimeDifference.between(self.created_at, Time.zone.now).in_hours.round(0)
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

  private
  def adjust_balances
    MoneyRequestService.new.adjust_balances(self.donation, self.withdrawal, self.amount)
  end

  def handle_status_update
    
    case MoneyTransaction.statuses[self.status]
      when MoneyTransaction.statuses[:completed]
        handle_transaction_completed
        
      when MoneyTransaction.statuses[:rejected]
        handle_transaction_rejected
        
      when MoneyTransaction.statuses[:blocked]
        handle_transaction_blocked
        
      when  MoneyTransaction.statuses[:pending]
        handle_transaction_reassigned
      else
        #DO NOTHING
    end
  end
  
  def handle_transaction_completed
    donation = self.donation
    donation.update(status: MoneyTransaction.statuses[:completed]) if donation.request_completed?
    
    withdrawal = self.withdrawal
    withdrawal.update(status: MoneyTransaction.statuses[:completed]) if withdrawal.request_completed?
  end
  
  def handle_transaction_rejected
    donation = self.donation
    donation.update!( status: MoneyTransaction.statuses[:rejected])
  end
  
  def handle_transaction_blocked
    donation = self.donation
    donation.update!(status: MoneyTransaction.statuses[:blocked]) unless donation.blocked?
    
    donation.money_transactions.each do |mt|
      withdrawal = mt.withdrawal
      withdrawal_balance = withdrawal.balance
      withdrawal_amount = withdrawal.amount
      if withdrawal_balance + mt.amount <= withdrawal_amount
        withdrawal.update!(balance: withdrawal_balance + mt.amount)
      end
      mt.update!(status: MoneyTransaction.statuses[:blocked]) unless mt.blocked?
    end
  end
  
  def handle_transaction_reassigned
    donation = self.donation
    donation.update!(status: MoneyTransaction.statuses[:pending])
  end
  
  def self.total
    MoneyTransaction.pluck(:amount).sum
  end

end
