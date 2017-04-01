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

FactoryGirl.define do
  factory :user do
    first_name 'First'
    last_name 'Last'
    sequence(:cellphone){ |e| "07123456#{e}" }
    sequence(:email){ |e| "first.last#{e}@email.com" }
    roles_mask 3
    password 'P@ssword'
  end
  
  factory :admin do
    roles_mask 1
  end
  
  factory :business do
    roles_mask 2
  end
end
