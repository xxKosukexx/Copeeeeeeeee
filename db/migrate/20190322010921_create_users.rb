class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :name
      t.string :uid
      t.string :password_digest

      t.timestamps
    end
  end
end
