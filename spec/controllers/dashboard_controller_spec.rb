require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    @user = create(:user)
    @abilities = Ability.new(@user)
    allow(@abilities).to receive(:can?).with(:manage, :PaymentAccount).and_return(true)
    allow(controller).to receive(:current_user).and_return(@user)
  end
  
end