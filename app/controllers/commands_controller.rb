class CommandsController < ApplicationController
  # コマンド操作で表示するメッセージ
  COMMAND_NEW_SUCCESS = "コマンドの追加に成功しました。"
  COMMAND_NEW_FAILURE = "コマンドの追加に失敗しました。"
  COMMAND_EDIT_SUCCESS = "コマンドの編集に成功しました。"
  COMMAND_EDIT_FAILURE = "コマンドの編集に失敗しました。"
  COMMAND_DESTROY_SUCCESS = "コマンドの削除に成功しました。"

  # commandモデルのfieldで使用する定数。
  COMMAND_FIELD_NAME_SIZE = 25
  COMMAND_FIELD_NAME_MAX_LENGTH = 20
  COMMAND_FIELD_CONTENTS_SIZE = 105
  COMMAND_FIELD_CONTENTS_MAX_LENGTH = 100
  COMMAND_FIELD_DESCRIPTION_SIZE = 205
  COMMAND_FIELD_DESCRIPTION_MAX_LENGTH = 200

  before_action :set_command, only: [:edit, :update, :destroy]

  #コマンド追加画面
  def new
    #コマンドを追加する際に、カテゴリidが必要なので、flashに設定する
    flash[:category_id] = params[:category_id]
    @command = Command.new
  end

  #コマンド追加
  def create
    #コマンドをカテゴリに関連づけるために取得する。
    category = Category.find(params[:category_id])
    # createメソッドで追加すると検証メッセージが表示されないため、newメソッドを使用する。
    @command = category.command.new(command_params)
    if @command.save
        command_operation_log(COMMAND_NEW_SUCCESS, params[:command][:name], params[:command][:contents], params[:command][:description])
        redirect_to command_management_show_url, notice: COMMAND_NEW_SUCCESS
    else
        command_operation_log(COMMAND_NEW_FAILURE, params[:command][:name], params[:command][:contents], params[:command][:description])
        #コマンドを再追加するために必要なコテゴリを再セットする。
        flash.now[:category_id] = params[:category_id]
        render :new
    end
  end

  #コマンド更新
  def update
    if @command.update(command_params)
        command_operation_log(COMMAND_EDIT_SUCCESS, params[:command][:name], params[:command][:contents], params[:command][:description])
        redirect_to command_management_show_url, notice: COMMAND_EDIT_SUCCESS
    else
        command_operation_log(COMMAND_EDIT_FAILURE, params[:command][:name], params[:command][:contents], params[:command][:description])
        render :edit
    end
  end

  #コマンド削除
  def destroy
    @command.destroy
    command_operation_log(COMMAND_DESTROY_SUCCESS, @command.name, @command.contents, @command.description)
    redirect_to command_management_show_url, notice: COMMAND_DESTROY_SUCCESS
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_command
      @command = Command.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def command_params
      params.require(:command).permit(:name, :contents, :description)
    end

    #コマンド関連の操作でログを残すためのメソッド
    def command_operation_log(log_message, command_name, command_contents, command_description)
      logger.debug("#{log_message} category_id:#{params[:category_id]} name:#{command_name} contents:#{command_contents} description:#{command_description}")
    end
end
