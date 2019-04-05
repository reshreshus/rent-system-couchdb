Rails.application.routes.draw do
  resources :categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Rails.application.routes.draw do
  # resources :categories
  resources :users
  resources :items
  resources :orders
  resources :subcategories
  resources :application
  get 'current_user', to: 'users#current_user'
  get '/users/:id/items', to: 'users#get_user_items'
  get '/categories/:id/subcategories', to: 'categories#get_subcategories'
  post 'authenticate', to: 'authentication#authenticate'
# end
end
