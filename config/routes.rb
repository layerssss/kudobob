Rails.application.routes.draw do
  devise_for :users, path: 'member'
  root to: 'pages#home'
  resources :dojos
  resources :users
  resources :scripts do 
    member do
      post :copy
    end
  end
  resources :public_scripts do
    member do
      post :copy
    end
  end
end
