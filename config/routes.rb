Rails.application.routes.draw do
  devise_for :users

  resources :transactions, only: [:create]
  namespace :users do
    get :current
  end


  unauthenticated :user do
    root to: 'pages#landing'
  end

  authenticated :user do
    root to: 'users#dashboard'
  end
end
