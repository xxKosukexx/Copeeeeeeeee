class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      #サービス認証用
      t.string :provider
      t.string :uid
      #通常認証用
      #理由はわからないが、サービス認証時のユーザー登録をする際、nameとpassword_digestにnullを設定すると、登録が行えないので文字列'nil'を設定する。
      t.string :name, default: 'nil'
      t.string :password_digest, default: 'nil'

      t.timestamps
    end
  end
end
