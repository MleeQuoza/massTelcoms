require 'rails_helper'

describe MoneyRequestService do
  before do
    @acc = create(:payment_account)
    @user = create(:user, payment_account: @acc)
    @params = { amount: 1000, balance: 1000 , status: 1, type: 'Donation', compounded: true, donation_id: nil }
    @donation = create(:donation, user: @user)
  end
  
  subject{ MoneyRequestService.new(@params) }
  
  describe 'call' do
    it 'creates a donation' do
      expect(MoneyRequest).to receive(:create).and_return @donation
      subject.call
    end
  end
  
end