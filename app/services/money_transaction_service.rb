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

    match_with_withdrawal
  end

  def match_with_donation
    Donation.where("balance >= #{amount} AND status = #{MoneyRequest.statuses[:pending]}").first&id
  end

  def donation_id
    return @money_request.id if @money_request.instance_of?Donation

    match_with_donation
  end

  def match_with_withdrawal
    Withdrawal.where("balance >= #{amount} AND status = #{MoneyRequest.statuses[:pending]}").first&id
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