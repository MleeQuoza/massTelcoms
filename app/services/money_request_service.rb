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
  
  def adjust_for_compound
      adjust_wallet_balance
      
    if @donation_id.present?
      adjust_donation_profit_from_date
    end
  end

  def adjust_balances(donation, withdrawal, transaction_amount)
    donation.adjust_balance(donation.balance - transaction_amount)
    withdrawal.adjust_balance(withdrawal.balance - transaction_amount)
  end

  private

  attr_reader :user_id, :amount, :balance, :status, :type, :compounded, :donation_id
  attr_writer :amount, :balance
  
  def status
    @compounded&.to_bool ? MoneyRequest.statuses[:completed] : MoneyRequest.statuses[:pending]
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
  
  def adjust_donation_profit_from_date
    donation = Donation.find(@donation_id)
    donation.update!(profit_from_date: Time.zone.now)
  end
  
  def adjust_wallet_balance
    user = User.find(user_id)
    wallet = user.wallet
    current_wallet_balance = wallet.balance
    new_wallet_balance = current_wallet_balance -  BigDecimal.new(@amount)
    wallet.update!(balance: new_wallet_balance, amount: current_wallet_balance + new_wallet_balance)
  
    @amount = BigDecimal.new(@amount) - BigDecimal.new(new_wallet_balance)
  end

end