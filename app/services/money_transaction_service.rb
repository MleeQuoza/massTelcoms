class MoneyTransactionService

  def initialize(money_request)
    @money_request = money_request
  end
  
  def match_with_donations
    donation = Donation.where("user_id != #{@money_request.user_id} AND balance >= #{@money_request.amount} AND status = #{MoneyRequest.statuses[:pending]}").first
    if donation
      make_transaction_for_withdrawal(donation, true)
    else
      collect_donations.each do |d|
        make_transaction_for_withdrawal(d)
      end
    end
  end
  
  def make_transaction_for_withdrawal(donation, use_request=false)
    MoneyTransaction.create(withdrawal_id: @money_request.id,
                            donation_id: donation.id,
                            amount: use_request ? @money_request.balance : donation.balance,
                            status: MoneyRequest.statuses[:pending])
  end
  
  def collect_donations
    donations = Donation.where("user_id != #{@money_request.user_id} AND balance > 0 AND status = #{MoneyRequest.statuses[:pending]} AND compounded = false").order(:balance).to_a
    sum = 0
    index = 0
    donations.each do |donation|
      break if sum > @money_request.balance
      sum += donation.balance
      index += 1
    end
    
    if sum <= @money_request.balance
      donations.slice(0..index)
    else
      []
    end
  end
  
  def match_with_withdrawals
    withdrawal = Withdrawal.where("user_id != #{@money_request.user_id} AND balance >= #{@money_request.amount} AND status = #{MoneyRequest.statuses[:pending]}").first
    if withdrawal.present?
      make_transaction_for_donation(withdrawal, true)
    else
      collect_withdrawals.each do |w|
        make_transaction_for_donation(w)
      end
    end
  end

  def make_transaction_for_donation(withdrawal, use_request=false)
    MoneyTransaction.create(withdrawal_id: withdrawal.id,
                            donation_id: @money_request.id,
                            amount: use_request ? @money_request.balance : withdrawal.balance,
                            status: MoneyRequest.statuses[:pending]
    )
  end
  
  def collect_withdrawals
    withdrawals = Withdrawal.where("user_id != #{@money_request.user_id} AND balance > 0 AND status = #{MoneyRequest.statuses[:pending]}").order(:balance).to_a
    sum = 0
    index = 0
    withdrawals.each do |withdrawal|
      break if sum >= @money_request.balance
      sum += withdrawal.balance
      index += 1
    end
    
    if sum == @money_request.balance
      withdrawals.slice(0..index)
    else
      []
    end
  end
end