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
    post 'default', to: 'addresses#default', as: :default
  end

  resource :aliases do
    root 'aliases#index'
    get ':id/edit', to: 'aliases#edit'
  end
end
