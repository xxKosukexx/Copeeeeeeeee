Rails.application.routes.draw do
  get 'service/info'
  resources :commands
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
