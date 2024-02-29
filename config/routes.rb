Rails.application.routes.draw do
  get 'messages/index'
  get 'conversations/index'

  get '/users', to: "users#show"
  put '/users', to: "users#create"
  patch '/users', to: "users#update"
  delete '/users', to: "users#destroy"

  get '/users/requests', to: 'requests#user_related', as: 'user_requests'
  post 'users/requests/:id/republish', to: 'requests#republish', as: 'republish'

  get '/requests', to: 'requests#index'
  put '/requests', to: 'requests#create'
  get '/requests/:id', to: 'requests#show', as: 'show_request'
  patch '/requests/:id', to: 'requests#update', as: 'update_request'
  delete '/requests/:id', to: 'requests#destroy', as: 'delete_request'

  post '/requests/:id/fulfill', to: 'requests#fulfill', as: 'fulfill_request'
  post '/requests/:id/volunteer', to: 'volunteers#volunteer', as: 'volunteer'

  post '/login', to: 'authentication#login'
  post '/upload', to: 'uploads#picture'

  resources :conversations, only: [:index, :create] do
    resources :messages, only: [:index, :create]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "requests#index"
end
