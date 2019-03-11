class UsersController < ApplicationController

  #ユーザー登録画面を呼び出すためのアクション
  def add
  end

  #ユーザー登録画面で入力された情報で、ユーザー登録をする
  def create
    @user = User.new(user_params)

    if @user.save
      #ログイン状態にする
      session[:user_id] = @user.id
      #コマンド管理画面に推移する
      render template: "command_management/show", notice: "ユーザー登録に成功しました。"
    else
      #ユーザー登録画面を再描画
      render action: :add, alert: "ユーザー登録に失敗しました。"
    end
  end

  #ユーザー削除画面を呼び出すためのアクション
  def delete
  end
  #ユーザー削除処理を行う
  def destroy
    if @user = User.new(user_params)
      #ユーザーidが同じならログイン情報を削除する。
      if @user.id == session[:user_id]
        reset_session
      end
      @book.destroy
      #トップページに推移する
      redirect_to '/', notice: 'ユーザー情報を削除しました。'
    else
      #ユーザー情報の取得に失敗した場合
      render action: :delete, alert: "ユーザー情報がすでに存在しません。"
    end
  end

  #twitterにてユーザー登録するアクション
  def twitter_add
  end

  #twitterのユーザー情報を削除するアクション
  def twitter_destroy
  end

  private

  #ユーザー登録画面に入力された情報を取得する
  def user_params
    params.require(:book).permit(:isbn, :title, :price, :publish, :published, :dl)
  end
end
