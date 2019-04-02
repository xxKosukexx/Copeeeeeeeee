class CommandManagementController < ApplicationController

  #コマンド管理画面を表示する
  def show
      #ユーザーに関連したカテゴリのみを抽出する。
      @categories = Category.where(user_id: session[:user_id])


      ###ymlファイルにてコマンドを取り込んだ際に取り込みに失敗していれば、メッセージが格納されているため、その内容を出力する。###
      #redirect_toで送ったパラメタは許可が必要なのでpermitする必要がある。
      take_in_failure_category = params.permit(take_in_failure_category: [])[:take_in_failure_category]
      take_in_failure_command = params.permit(take_in_failure_command: {})[:take_in_failure_command]

      if take_in_failure_category || take_in_failure_command
        flash[:take_in_failure_category] = take_in_failure_category
        flash[:take_in_failure_command] = take_in_failure_command
      end
  end

end
