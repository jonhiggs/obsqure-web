Obsqure::Application.routes.draw do
  #devise_for :users
  root to: 'welcome#index'

  devise_scope :user do
    get 'sign_in',  to: 'devise/sessions#new'
    get 'sign_out', to: 'devise/sessions#destroy'
  end

  devise_for :users, :controllers => {:registrations => "registrations"}

  get 'account', to: 'users#account'
  get 'contact', to: 'pages#contact'
  get 'faq', to: 'pages#faq'
  get 'manifesto', to: "pages#manifesto"
  get 'privacy', to: 'pages#privacy'
  get 'support', to: 'pages#support'
  get 'terms', to: 'pages#terms'
  get 'what-is-obsqure', to: 'pages#what_is_obsqure'

  get 'verify/:token', to: 'addresses#verify', as: :verify

  get 'file-not-found', to: 'pages#file_not_found'
  get 'internal-server-error', to: 'pages#internal_server_error'
  get 'access-denied', to: 'pages#access_denied'
  get 'maintenance', to: 'pages#maintenance'

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
