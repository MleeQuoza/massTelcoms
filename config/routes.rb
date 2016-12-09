Rails.application.routes.draw do
  root 'welcome#home'
  resources :dashboard
  devise_for :users
end
