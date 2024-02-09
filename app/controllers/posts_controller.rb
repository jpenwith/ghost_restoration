class PostsController < ApplicationController
  def index
    @offset = params[:offset].to_i || 0
    @posts = Rails.application.config.ghost.posts.slice(@offset, 10)

    for post in @posts
      post.load_restored_post()
    end
  end

  def read
    @post = Rails.application.config.ghost.post(params[:id])
    @post.load_restored_post()

    @days_range = (params[:days_range] || 3).to_i
    @index_last_offset = params[:index_last_offset].to_i || 0
  end

  def restore
    original_post = Rails.application.config.ghost.post(params[:id])

    params[:cards].keys.each do |key|
      card = params[:cards][key]

      raise "Count mismatch" unless card[:media_files].count === original_post.mobiledoc.cards[key.to_i].expected_media_files_count
    end

    restored_post = RestoredPost.new
    restored_post.original_post_uuid = original_post.uuid
    if params[:text].strip != original_post.plaintext.strip
      restored_post.text = params[:text].strip
    end
    restored_post.save!

    params[:cards].keys.each do |key|
      card = params[:cards][key]
      
      restored_post_card = RestoredPostCard.new
      restored_post_card.restored_post = restored_post
      restored_post_card.index = key.to_i
      restored_post_card.media_files = MediaFile.find(card[:media_files])

      restored_post_card.save!

    end

    redirect_to(action: 'index', params: { offset: params[:index_last_offset] })
  end
end
