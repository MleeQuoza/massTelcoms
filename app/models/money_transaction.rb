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

  enum status: { pending: 1, completed: 2, rejected: 3, blocked: 4 }

  after_commit on: [:create] do
    adjust_balances
  end
  
  after_commit on: [:update] do
    adjust_statuses
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
  
  def pending?
    self.status == 1
  end

  private
  def adjust_balances
    MoneyRequestService.new.adjust_balances(self.donation, self.withdrawal, self.amount)
  end

  def adjust_statuses
    donation = self.donation
    donation.update(status: 2) if donation.request_complete?
    
    withdrawal = self.withdrawal
    withdrawal.update(status: 2) if withdrawal.request_complete?
  end

end
