Rails.application.routes.draw do
  get 'lunch', to: 'menus#show'
end
