class RestoredPostCard < ApplicationRecord
    self.table_name = "restored_post_cards"

    belongs_to :restored_post
    has_many :restored_post_card_media_files
    has_many :media_files, through: :restored_post_card_media_files
end
