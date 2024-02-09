class RestoredPostCardMediaFile < ApplicationRecord
    self.table_name = "media_files_restored_post_cards"

    belongs_to :restored_post_card
    belongs_to :media_file
end
