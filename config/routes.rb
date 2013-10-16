Obsqure::Application.routes.draw do
  devise_for :users
  root to: 'welcome#index'

  devise_scope :user do
    get 'register', to: 'devise/registrations#new'
    get 'sign_in', to: 'devise/sessions#new'
    get 'sign_out', to: 'devise/sessions#destroy'
  end

  get 'account', to: 'users#account'
  get 'faq', to: 'pages#faq'
  get 'privacy', to: 'pages#privacy'
  get 'contact', to: 'pages#contact'
  get 'support', to: 'pages#support'
  get 'terms', to: 'pages#terms'
  get 'verify/:token', to: 'addresses#verify', as: :verify

  # verification
  get 'verify', to: 'addresses#verify'
  get 'not_verified', to: 'addresses#not_verified'

  resources :users do
    root 'users#index'
  end

  resources :addresses do
    root 'addresses#index'
    post 'default', to: 'addresses#default', as: :default
  end

  resource :aliases do
    root 'aliases#index'
    get  ':id/edit', to: 'aliases#edit'
    post ':id/burn', to: 'aliases#burn'
  end
end
