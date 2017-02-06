class MoneyRequestService

  def initialize(options = {}, name = {})
    options.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end

    name.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def call
    MoneyRequest.create(request_params)
  end

  def adjust_balances(donation, withdrawal, transaction_amount)
    donation.adjust_balance(donation.balance - transaction_amount)
    withdrawal.adjust_balance(withdrawal.balance - transaction_amount)
  end

  private

  attr_reader :user_id, :amount, :balance, :status, :type, :compounded

  def status
    MoneyRequest.statuses[:pending]
  end

  def balance
    @amount
  end

  def request_params
    { user_id: user_id, amount: amount, balance: balance, status: status, type: type, compounded: compounded }
  end

  def adjust_withdrawal_balance(withdrawal, transaction_amount)
    withdrawal.update(balance: (withdrawal.balance - transaction_amount))
  end

  def adjust_donation_balance(donation, transaction_amount)
    donation.update(balance: (donation.balance - transaction_amount))
  end
  

end