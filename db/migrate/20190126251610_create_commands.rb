class CreateCommands < ActiveRecord::Migration[5.2]
  def change
    create_table :commands do |t|

      t.string :name
      #コマンドの内容(100文字)と説明(200文字)はstring(varchar(255)255キロバイト)で十分入力できる。
      t.string :contents
      t.string :description, default: ""
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
