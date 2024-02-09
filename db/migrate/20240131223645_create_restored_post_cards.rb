class CreateRestoredPostCards < ActiveRecord::Migration[7.1]
  def change
    create_table :restored_post_cards do |t|
      t.integer :index, null: false

      t.timestamps
    end

    add_reference :restored_post_cards, :restored_post, foreign_key: true
    add_index :restored_post_cards, [:restored_post_id, :index], unique: true
  end
end
