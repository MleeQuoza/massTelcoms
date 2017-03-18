require 'rails_helper'

RSpec.describe MoneyTransactionsController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    account = create(:payment_account)
    @user = create(:user, payment_account: account)
    
    withdrawal_user = create(:user, payment_account: account)
    withdrawal = create(:withdrawal, user: withdrawal_user)
    donation = create(:donation)
    @money_transaction = create(:money_transaction, donation: donation, withdrawal: withdrawal, amount: 2000)
    @abilities = Ability.new(@user)
  
    allow(@abilities).to receive(:can?).with(:manage, :PaymentAccount).and_return(true)
    allow(controller).to receive(:current_user).and_return(@user)
  end
  
  describe 'index' do
    it 'renders index template' do
      get :index
      expect(response.status).to eq 200
      expect(response).to render_template :index
    end
    
  end
  
  
  describe 'toggle_transaction_status' do
    before do
      
    end
    
    context 'rejecting transaction' do
      it 'changes status to cancelled' do
        post :toggle_transaction_status, params: { id: @money_transaction.id , status: MoneyTransaction.statuses[:rejected] }
        
        expect(response.status).to eq 302
        expect(response).to redirect_to money_transactions_path
        mt = MoneyTransaction.last
        expect(mt.status).to eq 'rejected'
      end
    end

    context 'completing transaction' do
      it 'changes status to completed' do
        post :toggle_transaction_status, params: { id: @money_transaction.id , status: MoneyTransaction.statuses[:completed] }
    
        expect(response.status).to eq 302
        expect(response).to redirect_to money_transactions_path
        mt = MoneyTransaction.last
        expect(mt.status).to eq 'completed'
      end
    end
  end
end