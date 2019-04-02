class User < ApplicationRecord
  has_many :category, dependent: :destroy

  # パスワードの検証機能を追加する
  # 以下の内容が追加される
  # ・password／password_confirmationプロパティ
  # ・passwordプロパティの必須検証、文字列長検証（72文字以内
  # ・password／password_confirmationプロパティのconfirmation検証
  # ・認証のためのauthenticateメソッド
  has_secure_password
end
