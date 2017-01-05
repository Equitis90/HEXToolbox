Rails.application.routes.draw do
  get 'game_object/show'

  root 'index#show'
end
