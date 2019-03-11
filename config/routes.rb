Rails.application.routes.draw do


  resources :commands
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #get
  get 'users/add'
  get 'users/destroy'
  get 'users/twitter_add'
  get 'users/twitter_destroy'
  get 'auth/twitter'
  get '/auth/:provider/callback', to: 'authentication_management#twitter_login'
  get 'authentication_management/login'
  get 'authentication_management/logout'
  get 'authentication_management/entrance_screen'
  get 'categories/add'
  get 'categories/destroy'
  get 'categories/edit'
  get 'command_management/show'
  get 'command_management/clipboard'
  get 'service_info/info'
  get 'take_in_command_with_file/file_select'
  get 'take_in_command_with_file/teke_in_command'

  #post


  root to: 'authentication_management#entrance_screen'
end
