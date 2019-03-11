class ApplicationController < ActionController::Base
  #全ての画面を読み込む際にログインチェック処理を実施する。
  #before_action login_checked

  #認証済みかどうかを判定するcheck_loginedフィルターを定義
  private
  def check_logined
   #セッション情報：usr(id値)が存在するか
   if session[:user_id] then
     begin
       @user = User.find(session[:username])
       #ユーザー情報が存在しない場合は不正なユーザーとみなし、セッションを破棄
     rescue ActiveRecord::RecordNotFound
       reset_session
     end
   end

   #ユーザー情報が取得できなかった場合にはログインページ
   unless @user
     #ログイン後のページ推移のために、ページ情報を保持する
     flash[:after_login_page] = request.fullpath
     #ログイン失敗時に使用するコントローラー名とアクション名を保持する
     flash[:re_login_controller] = controller_name
     flash[:re_login_action] = action_name
     redirect_to controller: :authentication_management, action: :login
   end
  end
end
