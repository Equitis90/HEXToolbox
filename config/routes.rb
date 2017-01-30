Rails.application.routes.draw do
  get 'champion/list'

  get 'equipment/list'

  get 'game_object/show'

  root 'index#show'
end
