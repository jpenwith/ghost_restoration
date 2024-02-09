class CreateRestoredPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :restored_posts do |t|
      t.string :original_post_uuid, null: false, index: { unique: true }

      t.text :text

      t.timestamps
    end
  end
end
