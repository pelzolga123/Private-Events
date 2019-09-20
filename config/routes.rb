Rails.application.routes.draw do
  get 'users/new'
  root 'landing_pages#home'
  get '/home', to: 'landing_pages#home'
  get '/event', to: 'landing_pages#event'
  get '/signin', to: 'landing_pages#signin'

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
