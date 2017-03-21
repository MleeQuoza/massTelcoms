require 'rails_helper'

RSpec.describe WithdrawalsController, type: :controller do
  before do
    @user = create(:user, payment_account: create(:payment_account))
    @abilities = Ability.new(@user)
    
    allow(controller).to receive(:authenticate_user!).and_return true
    allow(@abilities).to receive(:can?).with(:manage, :PaymentAccount).and_return(true)
    allow(controller).to receive(:current_user).and_return(@user)
  end
  
  describe 'new' do
    it 'renders new template' do
      get :new
      
      expect(response.status).to eq 200
      expect(response).to render_template :new
    end
  end
  
  describe 'create' do
    it 'creates new withdrawal' do
      @user.wallet.update!(balance: 3000)
      
      expect(Withdrawal.count).to eq 0
      
      post :create, params: { user_id: @user.id, amount: 2000 },  as: :js
      
      expect(Withdrawal.count).to eq 1
      withdrawal = Withdrawal.first
      expect(withdrawal.user_id).to eq @user.id
      expect(withdrawal.amount).to eq 2000
      expect(@user.wallet.balance).to eq 1000
    end
  end
end
