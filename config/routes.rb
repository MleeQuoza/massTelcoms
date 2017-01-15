Rails.application.routes.draw do
  root 'welcome#home'
  resources :dashboard, only: [:index]
  resources :donations, only: [:new, :create]
  resources :withdrawals
  resources :payment_accounts
  devise_for :users

  match '/money_transactions/reject_transaction/:id' => 'money_transactions#reject_transaction', as: 'reject_transaction', via: :patch
  match '/money_transactions/complete_transaction/:id' => 'money_transactions#complete_transaction', as: 'complete_transaction', via: :patch
  match '/donations/:user_id' => 'donations#user_donations', as: 'user_donations', via: :get
end
