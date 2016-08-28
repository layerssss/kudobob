Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :dojos
  resources :users
  resources :scripts
end
