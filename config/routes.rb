Obsqure::Application.routes.draw do
  devise_for :users
  root to: 'welcome#index'

  resources :users do
    root 'users#index'
    resources :aliases
    resources :addresses
  end

  resources :faq

  resources :addresses do
    root 'addresses#index'
  end
end
