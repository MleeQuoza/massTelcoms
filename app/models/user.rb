# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           default(""), not null
#  last_name              :string           default(""), not null
#  cellphone              :string
#  referer_id             :integer
#  roles_mask             :integer
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :last_name, presence: :true
  validates :first_name, presence: :true
  
  has_one :wallet
  has_one :referral_wallet
  has_one :payment_account
  has_many :withdrawals
  has_many :donations
  

  after_commit on: [:create] do
    wallet = Wallet.new(user_id: self.id, amount: 0, balance: 0)
    wallet.save!

    rwallet = ReferralWallet.new(user_id: self.id, amount: 0, balance: 0)
    rwallet.save!
  end

  before_validation on: [:create] do
    self.guid = SecureRandom.hex(12) if guid.blank?
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def current_withdrawal
    self.withdrawals.where(status: MoneyRequest.statuses[:pending]).first
  end

  def current_donation
    self.donations.where(status: MoneyRequest.statuses[:pending]).first
  end

  def can_donate_or_withdraw?
     not (self.current_donation.present? || self.current_withdrawal.present?)
  end
  
  def bank_account
    self.payment_account || PaymentAccount.new
  end

  ROLES = %w[admin business user]

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def role?(role_name)
    return self.role.present? && self.role.name == role_name.to_s
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def referral_link
    "http://#{ENV['DOMAIN_NAME']}/users/sign_up?ref=#{self.guid}"
  end
  
  def total_referrals
    User.where(referer_guid: self.guid)
  end
  
  def new_referrals
    
  end
  
  def non_compounded_donations
    self.donations.where(compounded: false)
  end
end
