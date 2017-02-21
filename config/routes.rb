Rails.application.routes.draw do
  root 'welcome#home'
  
  resources :dashboard, only: [:index]
  resources :donations, only: [:new, :create]
  resources :withdrawals, only: [:new, :create]
  resources :payment_accounts
  resources :money_transactions, only: [:index]
  resources :tools
  resources :wallets, only: [:show]
  resources :adverts
  devise_for :users

  match '/wallets/add/' => 'wallets#add_to_wallet', via: :post, as: 'add_to_wallet'
  match '/wallets/add_bonus/' => 'wallets#add_bonus_to_wallet', via: :post, as: 'add_bonus_to_wallet'
  match '/wallets/withdraw/' => 'wallets#withdraw_from_wallet', via: :post, as: 'withdraw_from_wallet'
  match '/money_transactions/toggle_transaction_status/:id' => 'money_transactions#toggle_transaction_status', as: 'toggle_transaction_status', via: :post
  match '/donations/:user_id' => 'donations#user_donations', as: 'user_donations', via: :get
  match '/withdrawals/:user_id' => 'withdrawals#user_withdrawals', as: 'user_withdrawals', via: :get
  match '/dashboard/profile/:user_id' => 'dashboard#profile', as: 'profile', via: :get
  match 'welcome/how_to' => 'welcome#how_to', as: 'how_to_donate', via: :get
  match 'welcome/terms' => 'welcome#terms', as: 'terms', via: :get

end
