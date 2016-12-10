Rails.application.routes.draw do
  post 'messages/reply', to: 'messages#reply'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
