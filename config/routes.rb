Rails.application.routes.draw do
  root 'welcome#home'
  
  resources :dashboard, only: [:index]
  resources :donations, only: [:new, :create]
  resources :withdrawals, only: [:new, :create]
  resources :payment_accounts
  resources :money_transactions, only: [:index]
  resources :tools
  resources :wallets, only: [:show]
  devise_for :users, controllers: { registrations: 'registrations' }

  match '/wallets/add/' => 'wallets#add_to_wallet', via: :post, as: 'add_to_wallet'
  match '/wallets/withdraw/' => 'wallets#withdraw_from_wallet', via: :post, as: 'withdraw_from_wallet'
  match '/money_transactions/reject_transaction/:id' => 'money_transactions#reject_transaction', as: 'reject_transaction', via: :patch
  match '/money_transactions/complete_transaction/:id' => 'money_transactions#complete_transaction', as: 'complete_transaction', via: :patch
  match '/donations/:user_id' => 'donations#user_donations', as: 'user_donations', via: :get
  match '/withdrawals/:user_id' => 'withdrawals#user_withdrawals', as: 'user_withdrawals', via: :get
  match '/dashboard/profile/:user_id' => 'dashboard#profile', as: 'profile', via: :get
end
