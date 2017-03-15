class MoneyTransactionService

  def initialize(money_request)
    @money_request = money_request
  end
  
  def match_with_donations
    donation = Donation.where("user_id != #{@money_request.user_id} AND balance >= #{@money_request.amount} AND status = #{MoneyRequest.statuses[:pending]}").first
    if donation
      make_transaction_for_withdrawal(donation)
    else
      collect_donations
    end
  end
  
  def make_transaction_for_withdrawal(donation)
    MoneyTransaction.create(withdrawal_id: @money_request.id,
                            donation_id: donation.id,
                            amount: @money_request.amount,
                            status: MoneyRequest.statuses[:pending])
  end
  
  def collect_donations
    donations = Donation.where("user_id != #{@money_request.user_id} AND balance > 0 AND status = #{MoneyRequest.statuses[:pending]}")
    donation_basket = []
    sum = 0
    donations.each_with_index do |donation, index|
      return if sum >= @money_request.amount
    end
    
  end
  
  def match_with_withdrawals
    withdrawal = Withdrawal.where("user_id != #{@money_request.user_id} AND balance >= #{@money_request.amount} AND status = #{MoneyRequest.statuses[:pending]}").first
    if withdrawal.present?
      make_transaction_for_donation(withdrawal)
    else
      make_transactions_for_donation
    end
  end

  def make_transaction_for_donation(withdrawal)
    MoneyTransaction.create(withdrawal_id: withdrawal.id,
                            donation_id: @money_request.id,
                            amount: @money_request.amount,
                            status: MoneyRequest.statuses[:pending],
                            compounded: false
    )
  end
  
  def collect_withdrawals
    
  end
end