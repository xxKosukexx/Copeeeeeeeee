class UsersController < ApplicationController
  NORMAL_USER_AUTH_SUCCESS_MESSAGE = "ユーザー認証に成功しました。"
  NORMAL_USER_AUTH_FAILURE_MESSAGE = "ユーザー認証に失敗しました。"
  NORMAL_USER_DESTROY_SUCCESS_MESSAGE = "ユーザー情報を削除しました。"
  NORMAL_USER_DESTROY_NOT_EXIST_MESSAGE = "ユーザー情報が既に存在しません。"
  PROVIDER_USER_AUTH_SUCCESS_MESSAGE = "サービス認証に成功しました。"
  PROVIDER_USER_AUTH_FAILURE_MESSAGE = "サービス認証に失敗しました。時間をおいてから再度認証を行ってください。"
  PROVIDER_USER_DESTROY_SUCCESS_MESSAGE = "ユーザー情報を削除しました。"
  PROVIDER_USER_DESTROY_NOT_EXIST_MESSAGE = "ユーザー登録情報の削除に失敗しました。ユーザー登録がされていないか、ユーザー認証が行われていない可能性があります。"

  before_action :check_logined, except: [:new, :create, :delete, :destroy, :twitter_new, :provider_destroy]
  #ユーザー登録画面を呼び出すためのアクション
  def new
  end

  #ユーザー登録画面で入力された情報で、ユーザー登録をする
  def create
    usr = User.new(user_params)
    #サービス認証でないことを表す
    usr.provider ='normal'
    if usr.save
      #ログイン状態にする
      login_session(user_id: usr.id, username: usr.name)
      #コマンド管理画面に推移する
      redirect_to command_management_show_url, notice: NORMAL_USER_AUTH_SUCCESS_MESSAGE
    else
      #ユーザー登録画面を再描画
      render action: :new, alert: NORMAL_USER_AUTH_FAILURE_MESSAGE
    end
  end

  #ユーザー削除画面を呼び出すためのアクション
  def delete
  end
  #ユーザー削除処理を行う
  def destroy
    usr = User.find_by(provider: 'normal', name: params[:name])
    #ユーザー情報が取得できたか？
    if usr && usr.authenticate(params[:password])
      #ユーザーidが同じならログイン情報を削除する。
      if usr.id == session[:user_id]
        reset_session
      end
      usr.destroy
      #トップページに推移する
      redirect_to root_url, notice: NORMAL_USER_DESTROY_SUCCESS_MESSAGE
    else
      #ユーザー削除画面を再描画する
      render action: :delete, notice: NORMAL_USER_DESTROY_NOT_EXIST_MESSAGE
    end
  end

  #twitterにてユーザー登録するアクション
  def twitter_new
    provider_data = {}
    provider_data[:provider] = flash[:twitter_provider]
    provider_data[:uid] = flash[:twitter_uid]
    provider_data[:name] = flash[:twitter_name]

    #ユーザー登録がされていなければ、ユーザー登録を行い、ログイン状態にする。
    registration_login_result = provider_registration_and_login(provider_data)
    if registration_login_result
      #ユーザー登録がされている状態になったら、コマンド管理画面へ推移する。
      redirect_to command_management_show_url, notice: PROVIDER_USER_AUTH_SUCCESS_MESSAGE
    else
      redirect_to root_url, alert: PROVIDER_USER_AUTH_FAILURE_MESSAGE
    end
  end

  #サービス認証によってユーザー登録した情報を削除する
  #該当のサービス認証済みを前提とする
  def provider_destroy
    provider_name = ""
    if usr = User.find_by(id: session[:user_id])
      provider_name = usr.destroy
      self_made_method_log(__method__, "#{provider_name}認証による削除情報{user_id:#{usr.id}uid:#{usr.uid}")
      usr.destroy
      reset_session
      destroy_message = PROVIDER_USER_DESTROY_SUCCESS_MESSAGE
    else
      #ユーザー情報が取得できなかった場合はサービス名が取得できないので、「サービス認証による」というメッセージを表示するための文字列を格納する。。
      provider_name = "サービス"
      destroy_message = PROVIDER_USER_DESTROY_NOT_EXIST_MESSAGE
    end
    redirect_to root_url, notice: "#{provider_name}認証による#{destroy_message}"
  end

  #以下新たなサービスで認証処理を追加する時は以下の条件で判断する。
  # ・userテーブルに追加する時はサービス名（provider）を、ユーザー情報として追加する。
  # ・どのユーザーを識別する際は、uidを使用する。
  # ※調べたところ、どのサービスでもuidが取得できる。
  # ただし、uidはサービスによっては重複する可能性があるため、サービス名ごとのuidとして識別する。
  # 当コメントは新たにサービスを追加する際に、条件が分かりやすいように新たに追加したサービス認証の下に配置する。

  private

  #ユーザー登録画面に入力された情報を取得する
  def user_params
    params.require(:user).permit(:provider, :name, :password_digest, :uid)
  end

  #サービス認証によってユーザー登録を行う
  #ユーザー登録が完了、またはすでにユーザー登録されていた場合は、ログイン状態にする。
  def provider_registration_and_login(provider_data)
    registration_login_flg = true
    #ユーザー情報が存在しなかったらユーザー情報を登録する
    usr = nil
    unless usr = User.find_by(provider: provider_data[:provider], uid: provider_data[:uid])
      self_made_method_log(__method__, "ユーザーが存在しません。provider:#{provider_data[:provider]} uid:#{provider_data[:uid]}")
      usr = User.new(provider: provider_data[:provider], uid: provider_data[:uid], name: 'test', password_digest: 'test')
      unless usr.save
        self_made_method_log(__method__, "ユーザー登録に失敗しました。provider:#{provider_data[:provider]} uid:#{provider_data[:uid]}")
        registration_login_flg = false
      end
    end

    if registration_login_flg
      #ユーザ登録に成功、またはすでに登録済みならログイン状態にする
      login_session(user_id: usr.id, username: provider_data[:name] )
      self_made_method_log(__method__, "twitter認証後のログイン状態{user_id:#{session[:user_id]}username:#{session[:username]}")
      return true
    else
      return false
    end
  end


end
