Rails.application.routes.draw do
  post 'messages/reply', to: 'messages#reply'
  post 'messages/find_poll_addr', to: 'messages#find_poll_addr'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
