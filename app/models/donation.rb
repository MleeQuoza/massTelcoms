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
  
  before_commit on: [:create] do
    self.maturity_date = Time.zone.today + 6.months
    self.profit_from_date = Time.zone.today
  end
  
  after_commit on: [:create] do
    update_referral
  end
  
  def profit
    self.amount * (self.profit_counter / 100)
  end

  def expired?
    TimeDifference.between(self.created_at, self.maturity_date).in_months > 6
  end

  def profit_counter
    days_invested = TimeDifference.between(self.profit_from_date, Time.zone.today).in_days

    if days_invested > 30
      days_invested = days_invested % 30
    end

    days_invested < 1 ? 0 : days_invested
  end

  def months_invested
    number_of_months = TimeDifference.between(self.created_at, Time.zone.today).in_months
    number_of_months < 1 ? 0 : number_of_months
  end
  
  def update_referral
    user = self.user
    referrer = User.find_by_email(user.referrer_email)
    return unless referrer.present?
    
    referral = Referral.where(referee_id: user.id, referrer_id: referrer.id).first
    referral.update(bonus_amount: (self.amount * 0.1))
  end

  def donation_completed?
    self.money_transactions.where('status = 1').count == 0
  end
end
