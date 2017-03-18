require 'rails_helper'

RSpec.describe WalletService, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    @user = create(:user)
    @abilities = Ability.new(@user)
    allow(@abilities).to receive(:can?).with(:manage, :all).and_return(true)
    allow(controller).to receive(:current_user).and_return(@user)
  end
  
  describe 'add_to_wallet' do
    before do
      @user.wallet.update!(balance: 1000)
      @donation = create(:donation, profit_from_date: Time.zone.today - 3.months, amount: 1000)
    end
    
    it 'adds supplied amount to wallet balance' do
      
    end
    
  end
end