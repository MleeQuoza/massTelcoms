class MoneyTransactionService

  def initialize(money_request)
    @money_request = money_request
  end
  
  def make_withdrawal_transaction(donation, use_request=false, balance=0)
    MoneyTransaction.create(withdrawal_id: @money_request.id,
                            donation_id: donation.id,
                            amount: use_request ? balance : donation.balance,
                            status: MoneyRequest.statuses[:pending]).save!
  end
  
  def match_with_donations
    donations = Donation.where("user_id != #{@money_request.user_id} AND balance > 0 AND status = #{MoneyRequest.statuses[:pending]} AND compounded = false").order(:balance).to_a
    balance = @money_request.balance
    
    donations.each do |donation|
      return if balance <= 0
      
      if balance > donation.balance
        make_withdrawal_transaction(donation)
        balance -= donation.balance
      else
        make_withdrawal_transaction(donation, true, balance)
        balance -= balance
      end
    end
  end

  def make_donation_transaction(withdrawal, use_request=false, balance=0)
    MoneyTransaction.create(withdrawal_id: withdrawal.id,
                            donation_id: @money_request.id,
                            amount: use_request ? balance : withdrawal.balance,
                            status: MoneyRequest.statuses[:pending]
    )
  end
  
  def match_with_withdrawals
    withdrawals = Withdrawal.where("user_id != #{@money_request.user_id} AND balance > 0 AND status = #{MoneyRequest.statuses[:pending]}").order(:balance).to_a
    balance = @money_request.balance
    
    withdrawals.each do |withdrawal|
      return if balance <= 0

      if balance > withdrawal.balance
        make_donation_transaction(withdrawal)
        balance -= withdrawal.balance
      else
        make_donation_transaction(withdrawal, true, balance)
        balance -= balance
      end
    end
    
  end
end