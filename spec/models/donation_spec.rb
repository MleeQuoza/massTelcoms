# == Schema Information
#
# Table name: money_requests
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  type             :text
#  amount           :decimal(17, 4)
#  balance          :decimal(17, 4)
#  status           :integer          default("pending"), not null
#  maturity_date    :date
#  matured          :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  compounded       :boolean          default(FALSE)
#  profit_from_date :datetime
#

require 'rails_helper'

RSpec.describe Donation, type: :model do
  subject { create(:donation) }

  it { is_expected.to respond_to :amount, :balance, :user, :status, :maturity_date, :matured, :compounded, :profit_from_date }
  it { is_expected.to be_valid }
  
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
  
  describe 'amount is not present' do
    before { subject.amount = nil }
    it { is_expected.to_not be_valid }
  end
  
  describe 'user id is not present' do
    before { subject.user_id = nil }
    it { is_expected.to_not be_valid }
  end
  
  describe 'make_money_transactions' do
    context 'compounded donation' do
      before { subject.compounded = true }
      
      it 'does nothing' do
        expect(MoneyTransactionService).not_to receive(:new)
        subject.make_money_transactions
      end
    end

    context 'non compounded donation' do
      before { subject.compounded = false }
      
      it 'makes money_transactions' do
        expect(MoneyTransactionService).to receive_message_chain(:new, :match_with_withdrawals)
        subject.make_money_transactions
      end
    end
  end
  
  describe 'profit' do
    context 'new donation' do
      it 'calculates profit' do
        expect(subject.profit).to eq 0
      end
    end
    
    context 'donation in one month' do
      before do
        subject.profit_from_date = Time.zone.today - 30.days
        subject.amount = 1000
        subject.status = MoneyRequest.statuses[:completed]
      end
      it 'calculates profit' do
        expect(subject.profit).to eq 300.0
      end
    end
  end

  describe 'expired?' do
    context 'new donation' do
      it 'donation not expired' do
        expect(subject.expired?).to eq false
      end
    end
  
    context 'donation in 7 months' do
      before{ subject.created_at = Time.zone.today - 7.months }
      it 'expires donation' do
        expect(subject.expired?).to eq true
      end
    end
  end
  
  describe 'profit_counter' do
    context 'new donation' do
      it 'returns 0' do
        expect(subject.profit_counter).to eq 0
      end
    end
  
    context 'donation in 3 months' do
      before{ subject.profit_from_date = Time.zone.today + 3.days }
      it 'calculates days since last profit checkout' do
        expect(subject.profit_counter).to eq 3
      end
    end
  end
  
  describe 'months_invested' do
    context 'new donation' do
      it 'returns 0' do
        expect(subject.months_invested).to eq 0
      end
    end
  
    context 'donation in 3 months' do
      before{ subject.created_at = Time.zone.today + 3.months }
      it 'calculates days invested' do
        expect(subject.months_invested).to eq 3
      end
    end
  end
  
  describe 'update_referral_bonus_amount' do
    #TODO
  end
end
