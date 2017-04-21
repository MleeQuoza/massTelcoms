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
  has_many :donation_checkout_histories
  has_many :donations
  belongs_to :user
  
  validates :amount, presence: :true
  validates_numericality_of :amount, greater_than: 0
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
    donation_profit = 0
    return donation_profit unless MoneyRequest.statuses[self.status] == MoneyRequest.statuses[:completed]
    
    donation_profit = self.amount * 0.01 * self.total_days_invested # 1 % for every day invested
    
    if self.compounded_profits.present?
      donation_profit -= self.compounded_profits
    end
    
    if self.donation_checkout_histories.present?
      donation_profit -= self.donation_checkout_histories.pluck(:amount).sum
    end
    
    donation_profit
  end
  
  def compounded_profits
    profit_donations = self.donations
    return nil unless profit_donations.present?
    
    profit_donations.pluck(:amount).sum
  end
  
  def checked_out_profits
    checkouts = self.donation_checkout_histories
    return nil unless checkouts.present?
    
    checkouts.pluck(:amount).sum
  end

  def expired?
    TimeDifference.between(self.created_at, Time.zone.today).in_months > 6
  end

  def profit_counter
    return 0 if self.pending?
    days_invested = self.total_days_invested

    if days_invested > 30
      days_invested = days_invested % 30
    end

    days_invested
  end
  
  def total_days_invested
    TimeDifference.between(self.created_at, Time.zone.today).in_days.round(0)
  end
  
  def previous_profit_counter
    return 0 if self.pending?
    TimeDifference.between(self.created_at, self.profit_from_date).in_days.round(0)
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
  
  def self.unmatched
    Donation.where('balance > 0 and status = 1').to_a
  end
  
  def self.unmatched_total
    Donation.unmatched.map(&:balance).sum
  end
end
