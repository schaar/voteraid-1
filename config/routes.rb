Rails.application.routes.draw do

  root to: 'pages#index'

  # Pages routes:
  get '/about', to: 'pages#about'

  # Responders routes:
  get '/responders/new', to: 'responders#new', as: 'new_responder'
  post '/responders', to: 'responders#create'

  # Messages routes:
  post 'messages/reply', to: 'messages#reply'
  # post 'messages/find_poll_addr', to: 'messages#find_poll_addr'

  get '*path', to: 'pages#index'

  # resource :messages do
  #   collection do
  #     post 'reply'
  #   end
  # end

end
