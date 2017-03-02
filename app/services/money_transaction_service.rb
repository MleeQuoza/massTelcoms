class MoneyTransactionService

  def initialize(money_request)
    @money_request = money_request
  end

  def call
    MoneyTransaction.create(transaction_params) unless transaction_params.has_value?nil
  end

  private

  attr_reader :withdrawal_id, :donation_id, :amount, :status

  def status
    MoneyRequest.statuses[:pending]
  end

  def amount
    return @money_request.amount unless @money_request.balance < @money_request.amount

    @money_request.balance
  end

  def withdrawal_id
    return @money_request.id if @money_request.instance_of?Withdrawal

    match_with_withdrawal(@money_request.user_id)
  end

  def match_with_donation(user_id)
    donation = Donation.where("user_id != #{user_id} AND balance >= #{amount} AND status = #{MoneyRequest.statuses[:pending]}").first
    donation.id unless donation.blank?
  end

  def donation_id
    return @money_request.id if @money_request.instance_of?Donation

    match_with_donation(@money_request.user_id)
  end

  def match_with_withdrawal(user_id)
    withdrawal = Withdrawal.where("user_id != #{user_id} AND balance >= #{amount} AND status = #{MoneyRequest.statuses[:pending]}").first
    withdrawal.id unless withdrawal.blank?
  end

  def transaction_params
    {
      amount: amount,
      withdrawal_id: withdrawal_id,
      donation_id: donation_id,
      status: status
    }
  end
end