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

class Donation < MoneyRequest
  has_many :money_transaction
  belongs_to :user

  def profit
    self.amount * (self.profit_counter / 100)
  end

  def expired?
    TimeDifference.between(self.created_at, Time.zone.today).in_months > 6
  end

  def profit_counter
    days_invested = TimeDifference.between(self.created_at, Time.zone.today).in_days

    if days_invested > 30
      days_invested = days_invested % 30
    end

    days_invested < 1 ? 0 : days_invested
  end

  def months_invested
    number_of_months = TimeDifference.between(self.created_at, Time.zone.today).in_months
    number_of_months < 1 ? 0 : number_of_months
  end
end
