Obsqure::Application.routes.draw do
  devise_for :users
  root to: 'welcome#index'

  resources :users do
    root 'users#index'
  end

  resources :faq

  resources :addresses do
    root 'addresses#index'
    post 'verify', to: 'addresses#verify', as: :verify
  end

  resource :aliases do
    root 'aliases#index'
  end
end
