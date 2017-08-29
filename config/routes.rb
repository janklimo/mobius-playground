Rails.application.routes.draw do
  devise_for :users

  resources :transactions, only: [:create]

  unauthenticated :user do
    root to: 'pages#landing'
  end

  authenticated :user do
    root to: 'users#dashboard'
  end
end
