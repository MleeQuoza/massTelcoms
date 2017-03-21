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

class Donation < MoneyRequest
  has_many :money_transactions
  belongs_to :user
  
  validates :amount, presence: :true
  validates :user_id, presence: :true
  
  before_commit on: [:create] do
    self.maturity_date = Time.zone.today + 6.months
    self.profit_from_date = Time.zone.today
  end

  after_commit on: [:create] do
    make_money_transactions
  end
  
  after_commit on: [:update] do
    if self.request_completed?
      update_referral_bonus_amount
    end
  end

  def make_money_transactions
    return unless self.requires_transaction
    MoneyTransactionService.new(self).match_with_withdrawals
  end
  
  def profit
    return 0 unless MoneyRequest.statuses[self.status] == MoneyRequest.statuses[:completed]
    self.amount * (self.profit_counter / 100.0)
  end

  def expired?
    TimeDifference.between(self.created_at, Time.zone.today).in_months > 6
  end

  def profit_counter
    return 0 if self.pending?
    TimeDifference.between(self.profit_from_date, Time.zone.today).in_days.round(0)
  end

  def months_invested
    TimeDifference.between(self.created_at, Time.zone.today).in_months.round(0)
  end
  
  def update_referral_bonus_amount
    user = self.user
    referrer = User.find_by_email(user.referrer_email)
    return unless referrer.present?
    
    referral = Referral.where(referee_id: user.id, referrer_id: referrer.id).first
    referral.update(bonus_amount: (self.amount * 0.1))
  end
end
