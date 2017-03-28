Rails.application.routes.draw do
  root 'welcome#home'
  match 'welcome/how_to' => 'welcome#how_to', as: 'how_to_donate', via: :get
  match 'welcome/faq' => 'welcome#faq', as: 'faq', via: :get
  match 'welcome/terms' => 'welcome#terms', as: 'terms', via: :get
  devise_for :users
  
  namespace :api do
    namespace :v1 do
      resources :donations, only: [:index, :create, :destroy, :update]
      resources :withdrawals, only: [:index, :create, :destroy, :update]
      resources :dashboard, only: [:index]
      resources :donations, only: [:new, :edit, :create, :update]
      resources :withdrawals, only: [:new, :create]
      resources :payment_accounts
      resources :money_transactions, only: [:index]
      resources :tools
      resources :wallets, only: [:show]
      resources :adverts
      resources :announcements

      match '/wallets/add/' => 'wallets#add_to_wallet', via: :post, as: 'add_to_wallet'
      match '/wallets/add_bonus/' => 'wallets#add_bonus_to_wallet', via: :post, as: 'add_bonus_to_wallet'
      match '/wallets/withdraw/' => 'wallets#withdraw_from_wallet', via: :post, as: 'withdraw_from_wallet'
      match '/wallets/fund/' => 'wallets#fund_wallet', via: :put, as: 'fund_wallet'

      match '/money_transactions/toggle_transaction_status/:id' => 'money_transactions#toggle_transaction_status', as: 'toggle_transaction_status', via: :post

      match '/donations/:user_id' => 'donations#user_donations', as: 'user_donations', via: :get

      match '/withdrawals/:user_id' => 'withdrawals#user_withdrawals', as: 'user_withdrawals', via: :get

      match '/dashboard/admin' => 'dashboard#admin', as: 'dashboard_admin', via: :get
      match '/dashboard/testing' => 'dashboard#testing', as: 'testing', via: :get
      match '/dashboard/money_transactions' => 'dashboard#money_transactions', as: 'all_transactions', via: :get
      match '/dashboard/filter_money_transactions' => 'dashboard#filter_money_transactions', as: 'filter_money_transactions', via: :post
    end
  end
  

end
