class CreateRestoredPostCardsMediaFilesJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_join_table :restored_post_cards, :media_files do |t|
    end

    add_index :media_files_restored_post_cards, :media_file_id, unique: true
  end
end