class AuthenticationManagementController < ApplicationController
  #ログインに関するアクション
  def login
    #入力値に従ってユーザー情報を取得
    user = User.find_by(name: params[:username])
    #ユーザー情報が存在し、認証（authenticate）に成功したら
    if user && user.authenticate(params[:password]) then
      #成功した場合はid値をセッションに設定し、もともとの要求ページにリダイレクト
      reset_session
      session[:user_id] = user.id
      redirect_to params[:after_login_page]
    else
      #失敗した場合はflash[:after_login_page]を再セットし、ログインページを再描画
      flash.now[:after_login_page] = params[:after_login_page]
      @error = 'ユーザ名/パスワードが間違っています'
      #アクションを呼び直す
      render template: "#{params[:re_login_controller]}/#{params[:re_login_action]}"
    end
  end

  def twitter_login
  end

  #ログアウトに関するアクション
  def logout
    reset_session   #セッションを破棄する
    redirect to '/' #トップページに推移する
  end

  #サービスの入り口画面
  def entrance_screen
  end
end
