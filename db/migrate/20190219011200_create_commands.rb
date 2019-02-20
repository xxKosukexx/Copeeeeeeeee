class CreateCommands < ActiveRecord::Migration[5.2]
  def change
    create_table :commands do |t|
      t.string :name
      t.string :contents
      t.string :description, default: ''

      t.timestamps
    end
  end
end
