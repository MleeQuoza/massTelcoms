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
#  roles_mask             :integer
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  guid                   :text             not null
#  referer_guid           :text
#  referrer_email         :text
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :cellphone, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validate :referral_email_is_not_own_email
  
  has_one :wallet
  has_one :referral_wallet
  has_one :payment_account
  has_many :withdrawals
  has_many :donations
  has_many :adverts
  
  has_many :referees, class_name: 'Referral', foreign_key: 'referrer_id'

  devise :timeoutable, :timeout_in => 10.minutes

  after_commit on: [:create] do
    wallet = Wallet.new(user_id: self.id, amount: 0, balance: 0)
    wallet.save!

    rwallet = ReferralWallet.new(user_id: self.id, amount: 0, balance: 0)
    rwallet.save!
    
    update_referrer
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
    self.donations.where(status: MoneyRequest.statuses[:completed]).first
  end

  def pending_withdrawals
    self.withdrawals.where(status: MoneyRequest.statuses[:pending])
  end

  def rejected_donations
    self.donations.where(status: MoneyRequest.statuses[:rejected])
  end

  def pending_donations
    self.donations.where(status: MoneyRequest.statuses[:pending])
  end

  def donation_total
    sum = 0
    self.donations.where(status: MoneyRequest.statuses[:completed]).each{ |d| sum += d.amount }
    sum
  end

  def can_withdraw?
    pp self.current_withdrawal.blank?
    self.current_withdrawal.blank?
  end
  
  def completed_donations
    self.donations.where(status: MoneyRequest.statuses[:completed])
  end

  def completed_withdrawals
    self.withdrawals.where(status: MoneyRequest.statuses[:completed])
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
    self.role.present? && self.role.name == role_name.to_s
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def referral_link
    "https://communitywealthsa.group/users/sign_up?ref=#{self.guid}"
  end
  
  def non_compounded_donations
    self.donations.where('status = 1 OR status = 3 AND compounded = false')
  end
  
  def update_referrer
    
    if self.referrer_email.present?
      referrer = User.find_by_email(self.referrer_email)
    end
    
    if self.referer_guid.present?
      referrer = User.find_by_guid(self.referer_guid)
    end

    return unless referrer.present?

    referral = Referral.create(referrer_id: referrer.id, referee_id: self.id, bonus_paid_out: false)
    referral.save!
  end
  
  def referee_list
    User.find(self.referees.map{|r| r.referee_id })
  end
  
  def new_referees
    self.referees.where(bonus_paid_out: false)
  end
  
  def paying_referrals
    self.new_referees.where('bonus_amount > 0 AND bonus_paid_out = false')
  end

  def paying_referrals_list
    sql = %(select a.id,
            a.first_name,
            a.last_name,
            b.referee_id,
            b.referrer_id,
            b.bonus_paid_out,
            b.bonus_amount from users a inner join referrals b on a.id = b.referee_id
            where referrer_id = #{self.id}
            and b.bonus_paid_out = false
            and b.bonus_amount > 0 order by b.bonus_amount desc
          )
    ActiveRecord::Base.connection.exec_query(sql).to_hash
  end
  
  def active_referrals
    users = User.find(Referral.where(referrer_id: self.id).map{ |r| r.referee_id })
    users.each_with_object([]) do |user, memo|
        memo.append(user) if user.completed_donations.present?
    end
  end
  
  def referral_bonus
    paying_referrals = self.paying_referrals
    
    return 0 unless paying_referrals.present?
    sum = 0
    paying_referrals.each{ |r| sum += r.bonus_amount }
    sum
  end
  
  def referral_email_is_not_own_email
    if referrer_email.present? && referrer_email == email
      errors.add(:referrer_email, 'cannot be the same as your email')
    end
  end
  
  def pending_adverts
    self.adverts.where(status: Advert.statuses[:requested])
  end

  def published_adverts
    self.adverts.where(status: Advert.statuses[:published])
  end
  
  def self.active_users
    User.find(Donation.where(status: MoneyTransaction.statuses[:completed]).pluck(:user_id)).to_a
  end
  
  def self.inactive_users
    active = self.active_users
    User.all.each_with_object([]) do |u, memo|
      memo.push(u) unless active.include?(u)
    end
  end
  
  def my_shares
    Time.zone = 'Pretoria'
    cut_off_date = Time.zone.parse('2017-05-02')
    donation ||= Donation.order(:created_at).where('created_at < ? and status = ?',
                                                 cut_off_date,
                                                 MoneyRequest.statuses[:completed])
    
    return 0 unless donation.present?
    donation.first.amount / 1000
  end
end
