require 'rails_helper'

RSpec.describe Donation, type: :model do
  subject { create(:donation) }
  
  it { is_expected.to respond_to :amount, :balance, :user, :status, :maturity_date, :matured }

  describe 'requires_transaction' do
    context 'for a compounded donation' do
      before { subject.compounded = true }
      it 'returns false' do
        expect(subject.requires_transaction).to eq false
      end
    end

    context 'for a new donation' do
      it 'returns true' do
        expect(subject.requires_transaction).to eq true
      end
    end
    
  end
end