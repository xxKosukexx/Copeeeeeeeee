Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  # get
    # users
      get 'users/new'
      get 'users/delete'
      get 'users/destroy'
      get 'users/twitter_new'
      get 'users/provider_destroy'
    # サービス認証
      get 'auth/twitter'
      get '/auth/failure', to: 'service#entrance_screen'
      get '/auth/:provider/callback(.:format)', to: 'authentication_management#twitter_auth'
    # authentication_management
      get 'authentication_management/login'
      get 'authentication_management/auth'
      get 'authentication_management/twitter_auth'
      get 'authentication_management/logout'
    # categories
    # command_management
      get 'command_management/show'
      get 'command_management/clipboard'
      # service
      get 'service/info'
      get 'service/entrance_screen'
    # take_in_command_with_file
      get 'take_in_command_with_file/take_in_command_yml'
    # commands

  # post
      post '/users/destroy'
    # take_in_command_with_file
      post 'take_in_command_with_file/take_in_command_yml'
    # authentication_management
      post 'authentication_management/auth'
  # resourcesは単体get等より下に書かないと影響が出るので、この位置に記述する。
  # resources
  resources :users
  resources :categories
  resources :commands

  # topページ
  root to: 'service#entrance_screen'
end
