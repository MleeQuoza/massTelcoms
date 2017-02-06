FactoryGirl.define do
  factory :user do
    first_name 'First'
    last_name 'Last'
    email 'first.last@rmail.com'
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