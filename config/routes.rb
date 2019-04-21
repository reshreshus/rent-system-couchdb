Rails.application.routes.draw do
  resources :users
  resources :items
  resources :orders
  resources :subcategories
  resources :categories
  resources :application
  get 'current-user', to: 'users#current_user'
  # get '/users/:id/items', to: 'users#get_user_items'
  get '/my-items', to: 'users#get_user_items'
  get '/my-orders/rented', to: 'users#get_items_i_rented'
  get '/my-orders/rent', to: 'users#get_items_i_rent'
  get '/categories/:id/subcategories', to: 'categories#get_subcategories'
  get '/all-categories', to: 'categories#get_all_categories'
  get '/subcategories/:id/items', to: 'subcategories#show_items'
  post 'authenticate', to: 'authentication#authenticate'
end