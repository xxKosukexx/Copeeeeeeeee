class CategoriesController < ApplicationController
  CATEGORY_NEW_SUCCESS = "カテゴリの追加に成功しました。"
  CATEGORY_NEW_FAILURE = "カテゴリの追加に失敗しました。"
  CATEGORY_EDIT_SUCCESS = "カテゴリの編集に成功しました。"
  CATEGORY_EDIT_FAILURE = "カテゴリの編集に失敗しました。"
  CATEGORY_DESTROY_SUCCESS = "カテゴリの削除に成功しました。"

  before_action :set_category, only: [:edit, :update, :destroy]

  # カテゴリ追加画面
  def new
    @category = Category.new
  end

  # カテゴリ追加
  def create
    # カテゴリをユーザーに関連づけるために取得する。
    user = User.find(session[:user_id])
    if user.category.create(category_params)
      category_operation_log(CATEGORY_NEW_SUCCESS, params[:category][:name])
      redirect_to command_management_show_url, notice: CATEGORY_NEW_SUCCESS
    else
      category_operation_log(CATEGORY_NEW_FAILURE, params[:category][:name])
      render :new, alert: CATEGORY_NEW_FAILURE
    end
  end

  # カテゴリ更新
  def update
    if @category.update(category_params)
      category_operation_log(CATEGORY_EDIT_SUCCESS, params[:category][:name])
      redirect_to command_management_show_url, notice: CATEGORY_EDIT_SUCCESS
    else
      category_operation_log(CATEGORY_EDIT_FAILURE, params[:category][:name])
      render :edit, alert: CATEGORY_EDIT_FAILURE
    end
  end

  # カテゴリ削除
  def destroy
    @category.destroy
    category_operation_log(CATEGORY_DESTROY_SUCCESS, @category.name)
    redirect_to command_management_show_url, notice: CATEGORY_DESTROY_SUCCESS
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet,
    # only allow the white list through.
    def category_params
      params.require(:category).permit(:name)
    end

    #コマンド関連の操作でログを残すためのメソッド
    def category_operation_log(log_message, category_name)
      logger.debug("#{log_message} name:#{category_name}")
    end
end
