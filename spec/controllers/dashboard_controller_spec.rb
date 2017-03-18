require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    @user = create(:user, roles: ['user'])
    @abilities = Ability.new(@user)
    allow(@abilities).to receive(:can?).with(:manage, :PaymentAccount).and_return(true)
    allow(controller).to receive(:current_user).and_return(@user)
  end
  
  describe 'index' do
    context 'user is an admin' do
      before do
        @user.update!(roles: ['admin'])
      end
      
      it 'renders index template' do
        get :index
    
        expect(response.status).to eq 200
        expect(response).to render_template :admin
      end
    end
    
    context 'user is not admin' do
      it 'renders index template' do
        get :index
        
        expect(response.status).to eq 200
        expect(response).to render_template :index
      end
    end
  end
  
end