class CreateMediaFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :files do |t|
      t.text :path, null: false
      t.integer :size, null: false
      t.string :digest, null: false
      t.date :created_at, null: false
      t.string :kind, null: false
    end
  end
end
