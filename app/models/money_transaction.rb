# == Schema Information
#
# Table name: money_transactions
#
#  id               :integer          not null, primary key
#  withdrawal_id    :integer          not null
#  donation_id      :integer          not null
#  status           :integer          default("1"), not null
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

  def withdrawal_user_name
    self.withdrawal.user.name
  end

  def donation_user_name
    self.donation.user.name
  end

  private
  def adjust_balances
    MoneyRequestService.new.adjust_balances(self.donation, self.withdrawal, self.amount)
  end

end
