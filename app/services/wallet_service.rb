class WalletService
  def initialize(user)
    @wallet |= user.wallet
  end

  def add_to_wallet(amount)
    @wallet.update!(amount: @wallet.amount + amount)
  end

  def withdraw_from_wallet(amount)
    @wallet.update!(amount: @wallet.amount - amount)
  end
end