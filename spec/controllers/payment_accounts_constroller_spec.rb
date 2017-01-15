require 'rails_helper'

RSpec.describe PaymentAccountsController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
  end

  describe 'GET new' do
    it 'has status 200' do
      get :new
      expect(response.status).to eq (200)
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    it 'creates payment account' do
      post :create, params: { payment_account: { user_id: 1,
                              bank_name: 'FNB',
                              bank_holder_name: 'Account Holder',
                              account_number: '123456789',
                              branch_code: '123456'
                           }},
          session: { user_id: 1 }

      expect(PaymentAccount.count).to eq 1
      expect(response.status).to eq 302
      expect(response).to redirect_to :controller => 'dashboard', :action => 'user_donations'
      expect(flash[:notice]).to eq'Payment Account saved'

    end
  end

  describe 'GET edit' do
    it 'has status 200' do
      get :edit, params: { id: 1 }
      let(:record) { create(:payment_account) }
      expect(response.status).to eq (200)
      expect(response).to render_template :edit
    end
  end

end