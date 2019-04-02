class ApplicationController < ActionController::Base
  #form_fieldに関する定数
  FORM_FIELD_NAME_SIZE = 20
  FORM_FIELD_PASSWORD_SIZE = 20
  FORM_FIELD_NAME_MAX_LENGTH = 20
  FORM_FIELD_PASSWORD_MAX_LENGTH = 20

  #全ての画面を読み込む際にログインチェック処理を実施する。
  before_action :check_logined

  protected

  # ログイン済みかどうかを判定するcheck_loginedフィルターを定義
  def check_logined
    # セッション情報：usr(id値)が存在するか
    if session[:user_id]
     begin
       @user = User.find(session[:user_id])
       # ユーザー情報が存在しない場合は不正なユーザーとみなし、セッションを破棄
     rescue ActiveRecord::RecordNotFound
       reset_session
     end
    end

     # ユーザー情報が取得できなかった場合にはログインページ
     unless @user
       # ログイン後のページ推移のために、ページ情報を保持する
       flash[:after_login_page] = request.fullpath
       redirect_to authentication_management_login_url
     end
  end

  # ログイン状態にする
  def login_session(user_id:, username:)
    session[:user_id] = user_id
    session[:username] = username
    self_made_method_log(
        __method__,
        "user_id:#{session[:user_id]} username:#{session[:username]}"
      )
  end

  # 自作したメソッドでログを残す時に使用する
  def self_made_method_log(method_name, log_message)
    logger.debug("メソッド名{#{method_name}} ログメッセージ{#{log_message}}")
  end
end
