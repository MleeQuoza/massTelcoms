require 'rails_helper'

RSpec.describe WalletsController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    acc = create(:payment_account)
    @user = create(:user, payment_account: acc)
    allow(controller).to receive(:current_user).and_return(@user)
  end
  
  describe 'add_to_wallet' do
    before do
      @donation = create(:donation, user: @user, profit_from_date: (Time.zone.today - 3.months), amount: 1000)
    end
    
    it 'adds supplied amount to wallet balance' do
      post :add_to_wallet, params: { donation_id: @donation.id, user_id: @user.id, amount: 2000 }
      expect(@user.wallet.balance).to eq 2000
    end
    
    it 'resets donation profit_from_date' do
      post :add_to_wallet, params: { donation_id: @donation.id, user_id: @user.id, amount: 2000 }
      expect(@donation.profit_from_date).to eq Time.zone.today
    end
  end
  
  describe 'add_bonus_to_wallet' do
    before do
      create_list(:referral, 5, referrer_id: @user.id, bonus_amount: 1000, bonus_paid_out: false)
    end
    
    it 'adds bonus to wallet' do
      post :add_bonus_to_wallet, params: { user_id: @user.id, amount: 5000 }
      expect(@user.wallet.balance).to eq 5000
    end
    
    it 'updates referrals bonus_paid_out true' do
      post :add_bonus_to_wallet, params: { user_id: @user.id, amount: 5000 }
      ref1 = Referral.first
      ref5 = Referral.last
      
      expect(ref1.bonus_paid_out).to eq true
      expect(ref5.bonus_paid_out).to eq true
    end
  end
  
  describe 'withdraw from wallet' do
    before{ @user.wallet.update!(balance: 1000) }
    
    it 'creates a withdrawal request' do
      post :withdraw_from_wallet
      expect(Withdrawal.count).to eq 1
      withdrawal = Withdrawal.first
      expect(withdrawal.user_id).to eq @user.id
      expect(withdrawal.amount).to eq 1000
    end
    
    it 'resets wallet balance' do
      post :withdraw_from_wallet
      
      expect(@user.wallet.balance).to eq 0
    end
  end
end