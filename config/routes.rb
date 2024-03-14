Rails.application.routes.draw do
  get 'messages/index' # show all messages of a conversation
  get 'conversations/index' # all conversations of a request

  get '/users', to: "users#show" # show user info
  put '/users', to: "users#create" # create new user
  patch '/users', to: "users#update" # update user info
  delete '/users', to: "users#destroy" # delete user

  get '/users/requests', to: 'requests#user_related', as: 'user_requests' # show all requests of a user
  post '/users/requests/:id/republish', to: 'requests#republish', as: 'republish' # republish a request
  post '/users/requests/:id/fulfill', to: 'requests#fulfill', as: 'fulfill_request' # set request as fulfilled

  get '/requests', to: 'requests#index' # show all requests. If authenticated, show all requests that the user can volunteer
  get '/requests/count', to: 'requests#request_count'
  put '/requests', to: 'requests#create' # create a new request
  get '/requests/:id', to: 'requests#show', as: 'show_request' # show a request
  patch '/requests/:id', to: 'requests#update', as: 'update_request' # update a request
  delete '/requests/:id', to: 'requests#destroy', as: 'delete_request' # delete a request

  post '/requests/:id/volunteer', to: 'volunteers#volunteer', as: 'volunteer' # volunteer for a request

  get '/requests/:id/conversations', to: 'conversations#index', as: "request_conversations" # all conversations of a request
  get '/requests/:id/conversations/:conversation_id/messages', to: 'messages#index', as: 'conversation_messages' # show all messages of a conversation
  put '/requests/:id/conversations/:conversation_id/messages', to: 'messages#create', as: 'new_conversation_message' # add a message to a conversation

  get  '/session', to: 'authentication#check_session_status' # show user session
  post '/login', to: 'authentication#login' # login
  delete '/logout', to: 'authentication#logout' # logout
  post '/upload', to: 'uploads#picture' # upload picture for user
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "requests#index"
end
