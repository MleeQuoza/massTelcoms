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
