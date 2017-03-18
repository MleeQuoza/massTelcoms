require 'rails_helper'

RSpec.describe PaymentAccountsController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    @user = create(:user)
    @abilities = Ability.new(@user)
    allow(@abilities).to receive(:can?).with(:manage, :all).and_return(true)
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
    it 'creates a payment account' do
      params = { payment_account: { user_id: 1,
                                   bank_name: 'FNB',
                                   bank_holder_name: 'Account Holder',
                                   account_number: '123456789',
                                   branch_code: '123456'
      }}
      post :create, params: params

      expect(PaymentAccount.count).to eq 1
      expect(response.status).to eq 302
      expect(response).to redirect_to dashboard_index_path
    end
  end

  describe 'GET edit' do
    before do
      @account = create(:payment_account, user_id: @user.id)
    end
    
    it 'has status 200' do
      get :edit, params: { id: @account.id }
      expect(response.status).to eq (200)
      expect(response).to render_template :edit
    end
  end
  
  describe 'PATCH update' do
    before do
      @account = create(:payment_account, user_id: @user.id)
    end
    
    it 'updates the record' do
      params = { id: @account.id, payment_account: { account_number: '56781234', bank_name: 'Standard Bank'}}
      expect(@account.account_number).to eq('123456789')
      expect(@account.bank_name).to eq('FNB')
      
      patch :update, params: params
      @account.reload
      
      expect(@account.account_number).to eq('56781234')
      expect(@account.bank_name).to eq('Standard Bank')
    end
  end

end