Rails.application.routes.draw do


  resources :commands
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #get
  get 'users/new'
  get 'users/destroy'
  get 'users/twitter_new'
  get 'users/provider_destroy'
  get 'auth/twitter'
  get '/auth/:provider/callback', to: 'authentication_management#twitter_auth'
  get 'authentication_management/login'
  get 'authentication_management/auth'
  get 'authentication_management/twitter_auth'
  get 'authentication_management/logout'
  get 'categories/new'
  get 'categories/destroy'
  get 'categories/edit'
  get 'command_management/show'
  get 'command_management/clipboard'
  get 'service/info'
  get 'service/entrance_screen'
  get 'take_in_command_with_file/file_select'
  get 'take_in_command_with_file/teke_in_command'

  #post


  root to: 'service#entrance_screen'
end
