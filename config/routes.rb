Rails.application.routes.draw do

  get '/users', to: "users#show"
  put '/users', to: "users#create"
  patch '/users', to: "users#update"
  delete '/users', to: "users#destroy"

  get '/requests', to: 'requests#index'
  get '/users/requests', to: 'requests#user_requests_and_volunteerings'
  get '/requests/:id', to: 'requests#show'
  put '/requests', to: 'requests#create'
  patch '/requests', to: 'requests#update'
  delete '/requests/:id', to: 'requests#destroy'

  post '/login', to: 'authentication#login'
  post '/upload', to: 'uploads#picture'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
