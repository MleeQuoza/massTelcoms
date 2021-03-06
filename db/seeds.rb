# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(
  [
    { first_name: 'Sam', last_name: 'Smith', password: 'P@ssword', cellphone: '0712345678', email: 'usera@mail.com' },
    { first_name: 'James', last_name: 'Dean', password: 'P@ssword', cellphone: '0712345677', email: 'userb@mail.com' },
    { first_name: 'Shaun', last_name: 'James', password: 'P@ssword', cellphone: '0712345676', email: 'userc@mail.com' },
    { first_name: 'Pamella', last_name: 'Anderson-Lee', password: 'P@ssword', cellphone: '0712345675', email: 'userd@mail.com' },
    { first_name: 'Ziyanda', last_name: 'Ngoma', password: 'P@ssword', cellphone: '0712345674', email: 'usere@mail.com' },
    { first_name: 'Nomhle', last_name: 'Thema', password: 'P@ssword', cellphone: '0712345673', email: 'userf@mail.com' },
    { first_name: 'Siya', last_name: 'Vula', password: 'P@ssword', cellphone: '0712345672', email: 'userg@mail.com' },
    { first_name: 'Mzimkhulu', last_name: 'Bhe', password: 'P@ssword', cellphone: '0712345671', email: 'userh@mail.com' },
    { first_name: 'Amanda', last_name: 'Gwen', password: 'P@ssword', cellphone: '0712345679', email: 'useri@mail.com' },
    { first_name: 'Mmusi', last_name: 'Maimane', password: 'P@ssword', cellphone: '0712345669', email: 'userj@mail.com' },
    { first_name: 'Julius', last_name: 'Malema', password: 'P@ssword', cellphone: '0712345668', email: 'userk@mail.com' },
    { first_name: 'Wanelisa', last_name: 'Xaba', password: 'P@ssword', cellphone: '0712345667', email: 'userl@mail.com' },
    { first_name: 'Sakhi', last_name: 'Khaya', password: 'P@ssword', cellphone: '0712345665', email: 'userm@mail.com' },
    { first_name: 'Noku', last_name: 'Khanya', password: 'P@ssword', cellphone: '0712345664', email: 'usern@mail.com' },
    { first_name: 'Vusi', last_name: 'Nova', password: 'P@ssword', cellphone: '0712345663', email: 'usero@mail.com' },
    { first_name: 'Mandla', last_name: 'Nkosi', password: 'P@ssword', cellphone: '0712345662', email: 'userp@mail.com' },
    { first_name: 'Nolubabalo', last_name: 'Bunu', password: 'P@ssword', cellphone: '0712345661', email: 'userq@mail.com' },
    { first_name: 'Loyiso', last_name: 'Biki', password: 'P@ssword', cellphone: '0712345660', email: 'userr@mail.com' },
    { first_name: 'Litha', last_name: 'Kazi', password: 'P@ssword', cellphone: '0712345659', email: 'users@mail.com' },
    { first_name: 'Nozuko', last_name: 'Khakaza', password: 'P@ssword', cellphone: '0712345658', email: 'usert@mail.com' },
    { first_name: 'Gama', last_name: 'Lakhe', password: 'P@ssword', cellphone: '0712345657', email: 'useru@mail.com' },
    { first_name: 'Lona', last_name: 'Linamandla', password: 'P@ssword', cellphone: '0712345656', email: 'userv@mail.com' }
  ]
)

User.create([
  {first_name: 'Miles', last_name: 'Davis', password: 'P@ssword', cellphone: '0712345655', email: 'userw@mail.com', referrer_email: 'usera@mail.com'},
  {first_name: 'Bruno', last_name: 'Mars', password: 'P@ssword', cellphone: '0712345654', email: 'userx@mail.com', referrer_email: 'usera@mail.com'},
  {first_name: 'Steve', last_name: 'Carrel', password: 'P@ssword', cellphone: '0712345653', email: 'usery@mail.com', referrer_email: 'usera@mail.com'},
  {first_name: 'Dave', last_name: 'Jones', password: 'P@ssword', cellphone: '0712345652', email: 'userz@mail.com', referrer_email: 'usera@mail.com'}
])

User.all.each do |u|
  PaymentAccount.create(user_id: u.id, bank_name: 'Absa', account_number: '40735679000', branch_code: '123456', account_type: 'Cheque')
end

Donation.create([
  {user_id: 11, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 12, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 13, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 14, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 15, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 16, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 17, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 18, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 19, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 20, amount: 1000, balance: 1000, compounded: false, status: 1 }
])

Withdrawal.create([
  {user_id: 1, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 2, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 3, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 4, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 5, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 6, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 7, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 8, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 9, amount: 1000, balance: 1000, compounded: false, status: 1 },
  {user_id: 10, amount: 1000, balance: 1000, compounded: false, status: 1 }
])
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')