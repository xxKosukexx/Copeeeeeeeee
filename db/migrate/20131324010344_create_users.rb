class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      #サービス認証用
      t.string :provider
      t.string :uid
      #通常認証用
      t.string :name
      t.string :password_digest

      t.timestamps
    end
  end
end
