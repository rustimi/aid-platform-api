Rails.application.routes.draw do
  get 'messages/index'
  get 'conversations/index'

  get '/users', to: "users#show"
  put '/users', to: "users#create"
  patch '/users', to: "users#update"
  delete '/users', to: "users#destroy"

  get '/users/requests', to: 'requests#user_related', as: 'user_requests'
  post '/users/requests/:id/republish', to: 'requests#republish', as: 'republish'
  post '/users/requests/:id/fulfill', to: 'requests#fulfill', as: 'fulfill_request'

  get '/requests', to: 'requests#index'
  put '/requests', to: 'requests#create'
  get '/requests/:id', to: 'requests#show', as: 'show_request'
  patch '/requests/:id', to: 'requests#update', as: 'update_request'
  delete '/requests/:id', to: 'requests#destroy', as: 'delete_request'

  post '/requests/:id/volunteer', to: 'volunteers#volunteer', as: 'volunteer'

  get '/requests/:id/conversations', to: 'conversations#index' # all conversations of a request
  get '/requests/:id/conversations/:conversation_id/messages', to: 'messages#index', as: 'conversation_messages' # show all messages of a conversation
  put '/requests/:id/conversations/:conversation_id/messages', to: 'messages#create' # add a message to a conversation

  post '/login', to: 'authentication#login'
  post '/upload', to: 'uploads#picture'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "requests#index"
end
