Obsqure::Application.routes.draw do
  devise_for :users
  root to: 'welcome#index'

  get 'account', to: 'users#account'

  devise_scope :user do
    get 'register', to: 'devise/registrations#new'
    get 'sign_in', to: 'devise/sessions#new'
  end

  # verification
  get 'verify', to: 'addresses#verify'
  get 'not_verified', to: 'addresses#not_verified'

  resources :users do
    root 'users#index'
  end

  resources :faq

  resources :addresses do
    root 'addresses#index'
    post 'default', to: 'addresses#default', as: :default
  end

  resource :aliases do
    root 'aliases#index'
    get ':id/edit', to: 'aliases#edit'
  end
end
