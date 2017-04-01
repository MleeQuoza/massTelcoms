require 'rails_helper'

RSpec.describe Withdrawal, type: :model do
  before do
    @acc = create(:payment_account)
    @user = create(:user, payment_account: @acc)
  end
  let(:acc){ create(:payment_account) }
  let(:user){ create(:user, payment_account: acc) }
  
  subject { create(:withdrawal, user: user, amount: 1000, balance: 1000) }

  it { is_expected.to respond_to :amount, :balance, :user, :status }
  it { is_expected.to be_valid }

  describe 'make_money_transactions' do
    it 'makes money_transactions' do
      #TODO fix me
      #expect(MoneyTransactionService).to receive_message_chain(:new, :match_with_donations)
      #subject.make_money_transactions
    end
  end
  
  describe 'pending_money_transactions' do
    context 'withdrawal with pending transactions' do
      it 'returns pending transactions' do
        expect(subject.pending_money_transactions.count).to eq 1
      end
    end

    context 'withdrawal with NO pending transactions' do
      
      it 'returns []' do
        expect(subject.pending_money_transactions).to eq []
      end
    end
  end

end