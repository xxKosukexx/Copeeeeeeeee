class TakeInCommandWithFileController < ApplicationController
TAKE_IN_SUCCESS_MESSAGE = "コマンドの取り込みに成功しました"
TAKE_IN_FAILURE_MESSAGE = "全てのコマンドの取り込みに失敗しました"
TAKE_IN_NOT_YML_MESSAGE = "アップロードできるのはymlファイルのみです。"
TAKE_IN_FILE_SIZE_OVER_MESSAGE = "ファイルサイズは1MBまでです。"
PERMS_FILE_TYPE = ['.yml']
PERMS_FILE_SIZE_MEGABYTE = 1

module FileUpLoadResult
  FILE_UP_LOAD_SUCCESS = 'file_up_load_success'
  FILE_UP_LOAD_FAILURE = 'file_up_load_failure'
  NG_EXTENSION = 'ng_extension'
  FILE_SIZE_OVER = 'file_size_over'
end

module TakeInResult
  TAKE_IN_SUCCESS = 'take_in_success'
  TAKE_IN_FAILURE = 'take_in_failure'
  FILE_READ_FAILURE = 'file_read_failure'
end


  def take_in_command_yml
    #アップロードファイルを取得
    yml_file_obj = params[:upfile]
    #ファイル名を拡張子付きで取得する。
    file_name = yml_file_obj.original_filename
    logger.debug("ファイル名：#{file_name}")
    #取得したymlファイルをuploadする
    create_directory_path = "public/docs/file_command"
    result = upload_file(yml_file_obj, create_directory_path, PERMS_FILE_TYPE, PERMS_FILE_SIZE_MEGABYTE)

    #uploadしたファイルからコマンドを取り込む
    yml_file_path = "#{create_directory_path}/#{file_name}"
    take_in_failure_category = []
    take_in_failure_command = {}
    #ファイル読み込み失敗時をログに出力するためにあえて　if () && () にしない。
    if FileUpLoadResult::FILE_UP_LOAD_SUCCESS == result
      if take_in_yml = YAML.load_file(yml_file_path)
        #取り込みに失敗した場合はメッセージを上書きする。
        result = TakeInResult::TAKE_IN_SUCCESS
        #取得したデータからコマンドを追加していく。
        take_in_yml.each do |take_in_data|
          #カテゴリ名がすでに存在していた場合は、カテゴリを取得してコマンドを追加。
          #存在しなかった場合は、新規でカテゴリを追加してからコマンドを追加する。
          unless category = Category.find_by(user_id: session[:user_id], name: take_in_data["category_name"])
            user = User.find(session[:user_id])
            category = user.category.create(name: take_in_data["category_name"])
          end

          #取得したカテゴリにコマンドを追加していく
          take_in_failure_command["#{take_in_data["category_name"]}"] = []
          if category
            take_in_data["command"].each do |command_data|
              unless category.command.create(name: command_data["name"], contents: command_data["contents"], description: command_data["description"])
                #コマンド追加に失敗したものを出力するために配列に格納
                take_in_failure_command["#{take_in_data["category_name"]}"] << command_data["name"]
                result = TakeInResult::TAKE_IN_FAILURE
              end
            end
          else #カテゴリの追加に失敗したものを出力するために配列に格納
            take_in_failure_category << take_in_data["category_name"]
            result = TakeInResult::TAKE_IN_FAILURE
          end
        end
      else
        result = TakeInResult::FILE_READ_FAILURE
        logger.debug("#{file_name}の読み込みに失敗しました。")
      end
    end

    #uploadしたfileごとディレクトリを削除する。
    delete_directory_path = create_directory_path
    FileUtils.rm_rf(delete_directory_path)

    #結果によって画面出力するメッセージを変更する。
    case result
    when FileUpLoadResult::FILE_UP_LOAD_FAILURE, TakeInResult::TAKE_IN_FAILURE, TakeInResult::FILE_READ_FAILURE then
      result_message = TAKE_IN_FAILURE_MESSAGE
    when FileUpLoadResult::NG_EXTENSION then
      result_message = TAKE_IN_NOT_YML_MESSAGE
    when FileUpLoadResult::FILE_SIZE_OVER then
      result_message = TAKE_IN_FILE_SIZE_OVER_MESSAGE
    when TakeInResult::TAKE_IN_SUCCESS then
      result_message = TAKE_IN_SUCCESS_MESSAGE
    end

    #実行結果をログに出力する。
    logger.debug("実行結果：#{result_message}")
    if TakeInResult::TAKE_IN_FAILURE == result
      logger.debug("追加できなかったカテゴリ：#{take_in_failure_category}")
      logger.debug("追加できなかったコマンド：#{take_in_failure_command}")
    end

    #成功/エラーメッセージを保存
    redirect_to command_management_show_url(take_in_failure_category: take_in_failure_category, take_in_failure_command: take_in_failure_command), notice: result_message
  end

  private
    def upload_file(file_obj, create_directory_path, perms_file_type, perms_file_size)
      result = FileUpLoadResult::FILE_UP_LOAD_SUCCESS
      #ファイルベース名（パスを除いた部分）を取得
      file_name = file_obj.original_filename
      #formで取得したymlファイルはそのままではハッシュ化できないので、一度uploadする。
      FileUtils.mkdir_p(create_directory_path) unless FileTest.exist?(create_directory_path)
      #配列permsにアップロードファイルの拡張子に合致するものがあるか
      if !perms_file_type.include?(File.extname(file_name).downcase)
        result = FileUpLoadResult::NG_EXTENSION
        logger.debug("#{file_name}が指定された拡張子とは異なる。指定された拡張子:#{perms_file_type}")

      elsif file_obj.size > perms_file_size.megabyte
        result = FileUpLoadResult::FILE_SIZE_OVER
        logger.debug("#{file_name}のサイズが指定されたサイズより大きい。指定されたサイズ：#{perms_file_size}")
      else
        #/public/docsフォルダ配下にアップロードファイルを保存
        create_file_path = "#{create_directory_path}/#{file_name}"
        unless File.open( create_file_path , 'wb' ){ |f| f.write( file_obj.read ) }
          result = TakeInResult::FILE_UP_LOAD_FAILURE
          logger.debug("#{file_name}のuploadに失敗しました。")
        end
      end
      return result
    end

end
