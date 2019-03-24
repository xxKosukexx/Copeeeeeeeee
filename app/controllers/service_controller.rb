class ServiceController < ApplicationController
  before_action :check_logined, except: [:info, :entrance_screen]

  #サービスの入り口の画面
  def entrance_screen
    #ログイン状態ではサービスの入り口画面へ推移する必要がない。
    #ログイン状態ならコマンド管理画面へ推移する
    if session[:user_id]
      redirect_to command_management_show_url
    end
  end

end
