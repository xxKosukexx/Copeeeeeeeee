class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  VALIDATES_PRESENCE_MESSAGE = 'は入力が必須です。'
  VALIDATES_UNIQUNESS_MESSAGE = '「%{value}」はすでに使用されています。'
  VALIDATES_LENGTH_MINIMUM_MESSAGE = 'は%{count}文字以上で入力してください。'
  VALIDATES_LENGTH_MINIMUM_COUNT = 8
  VALIDATES_PASSWORD_FORMAT_WITH = /\A[A-Z][a-zA-Z0-9]*\z/
  VALIDATES_PASSWORD_FORMAT_MESSAGE = "パスワードが正しくありません。以下の形式になっていることを確認してください。
                                      ・半角英数字になっていること。
                                      ・先頭が大文字であること。
                                      ・先頭に数字が使われていないこと"

end
