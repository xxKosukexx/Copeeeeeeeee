class User < ApplicationRecord
  # アソシエーションを付与する。
  has_many :category, dependent: :destroy

  # パスワードの検証機能を追加する
  # 以下の内容が追加される
  # ・password／password_confirmationプロパティ
  # ・passwordプロパティの必須検証、文字列長検証（72文字以内
  # ・password／password_confirmationプロパティのconfirmation検証
  # ・認証のためのauthenticateメソッド
  has_secure_password

  # userモデルに検証機能を実装する。
  # userモデルでuniqunessを使用すると、サービス認証でユーザー登録ができなくなる。
  # ユーザー名が一意であることを調べるにはrailsのvalidates機能は使用しない。
  # 自前で一意であるか検証する。
  # サービス認証時のユーザー登録時にvalidatesで設定した値を入力する必要があるので、
  # validatesを追加した際はUsersController::provider_registration_and_login
  validates :name,
    presence: { message: VALIDATES_PRESENCE_MESSAGE}
    # uniqueness: { message: VALIDATES_UNIQUNESS_MESSAGE}
  validates :password,
    presence: { message: VALIDATES_PRESENCE_MESSAGE},
    length: {
      minimum: VALIDATES_LENGTH_MINIMUM_COUNT,
      message: VALIDATES_LENGTH_MINIMUM_MESSAGE },
    format:{
      with: VALIDATES_PASSWORD_FORMAT_WITH,
      message: VALIDATES_PASSWORD_FORMAT_MESSAGE}

end
