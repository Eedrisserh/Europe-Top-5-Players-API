Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :players
  resources :home

  root to: 'home#index'
  devise_scope :user do
    authenticated :user do
      root to: 'home#index', as: :authenticated_root
      get '/users/sign_out', to: 'devise/sessions#destroy'
    end

    unauthenticated do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end