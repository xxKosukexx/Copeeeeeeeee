class CommandManagementController < ApplicationController

  #コマンド管理画面を表示する
  def show
      @categories = Category.includes(:commands).all
  end

  def clipboard
  end


end
