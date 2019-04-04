class AuthenticationManagementController < ApplicationController
  LOGIN_MESSAGE = "ログインしました。"
  LOGOUT_MESSAGE = "ログアウトしました。"
  LOGIN_ERROR = "ユーザ名/パスワードが間違っています"

  before_action :check_logined, except: [:login, :auth, :twitter_auth, :logout]
  #ログイン画面表示用
  def login
  end

  #入力された情報で認証処理を実施する
  def auth
    #入力値に従ってユーザー情報を取得
    usr = User.find_by(provider: 'normal', name: params[:username])
    #ユーザー情報が存在し、認証（authenticate）に成功したら
    if usr && usr.authenticate(params[:password]) then
      #成功した場合はid値をセッションに設定し、もともとの要求ページにリダイレクト
      reset_session
      #ログイン状態にする
      login_session(user_id: usr.id, username: usr.name)
      redirect_to params[:after_login_page], notice: LOGIN_MESSAGE
    else
      #失敗した場合はflash[:after_login_page]を再セットし、ログインページを再描画
      flash.now[:after_login_page] = params[:after_login_page]
      @error = LOGIN_ERROR
      logger.debug(LOGIN_ERROR)
      render :login
    end
  end

  def twitter_auth
    #以下で認証に関する処理を追加する。
    #取得したデータが不正でなければ、ユーザー登録(users/twitter_new)を実施する
    #現在は特になし
    #ユーザー登録処理で使用するために、フラッシュにデータを設定する。
    #そのまま渡すとデータサイズが大きすぎてエラーになるため、必要な分だけ渡す
    auth_data = request.env['omniauth.auth']
    logger.debug("provider:#{request.env['omniauth.auth'][:provider]} name:#{request.env['omniauth.auth'][:info][:name]}")
    flash[:twitter_provider] = auth_data[:provider]
    flash[:twitter_uid] = auth_data[:uid]
    flash[:twitter_name] = auth_data[:info][:name]
    redirect_to users_twitter_new_url
  end

  #ログアウトに関するアクション
  def logout
    logger.debug("#{LOGOUT_MESSAGE} user_id:#{session[:user_id]} username:#{session[:username]}")
    reset_session   #セッションを破棄する
    redirect_to root_path, notice: LOGOUT_MESSAGE #トップページに推移する
  end


end
