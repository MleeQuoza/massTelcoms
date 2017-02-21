require 'rails_helper'

RSpec.describe DonationsController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    @user = create(:user)
    @abilities = Ability.new(@user)
    allow(@abilities).to receive(:can?).with(:manage, :PaymentAccount).and_return(true)
    allow(controller).to receive(:current_user).and_return(@user)
  end
  
  describe 'GET new' do
    it 'has status 200' do
      get :new
      expect(response.status).to eq (200)
      expect(response).to render_template :new
    end
  end
  
  describe 'POST create' do
    context 'donation from user' do
      before do
        create(:withdrawal)
        @params = {user_id: @user.id, amount: 10000 }
      end
      
      it 'adds a new donation' do
        post :create, params: @params
        expect(Donation.count).to eq 1
      end
      
      it 'kicks off create money transaction' do
        expect(MoneyTransaction.count).to eq 0
        
        post :create, params: @params
        expect(MoneyTransaction.count).to eq 1
      end
    end
    
    context 'compounded donation' do
      before do
        create(:withdrawal)
        @donation = create(:donation, profit_from_date: (Time.zone.now - 2.months))
        @params = {user_id: @user.id, amount: 2000, compounded: true, donation_id: @donation.id }
      end
      
      it 'adds a new donation' do
        post :create, params: @params
        expect(Donation.count).to eq 2
      end
      
      it 'updates compounded donation profit_from_date' do
        post :create, params: @params
        expect(@donation.profit_from_date).to eq Time.zone.today
      end
      
      it 'does not kick off create money_transaction' do
        expect(MoneyTransaction.count).to eq 1
        
        post :create, params: @params
        expect(MoneyTransaction.count).to eq 1
      end
    end
    
  end

end
