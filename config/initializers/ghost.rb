require 'json'

file = File.read(Rails.root + 'storage' + 'ghost.json')

class Ghost
    attr_reader :posts

    def initialize(file)
        json = JSON.parse(file)

        @posts = (json['db'][0]['data']['posts'].map{ |post_json| Post.new(post_json) }).sort_by(&:published_at)

    end

    def post(uuid)
        @posts.find do |post|
          post.uuid === uuid
        end
    end

    class Post
        attr_reader :id
        attr_reader :uuid
        attr_reader :title
        attr_reader :mobiledoc
        attr_reader :html
        attr_reader :plaintext
        attr_reader :created_at
        attr_reader :published_at
        
        attr_accessor :restored_post

        def initialize(json)
            @id = json['id']
            @uuid = json['uuid']
            @title = json['title']
            @hmtl = json['hmtl']
            @plaintext = json['plaintext']
            @created_at = Time.parse(json['created_at'])
            @published_at = Time.parse(json['published_at'])

            @mobiledoc = Mobiledoc.new(JSON.parse(json['mobiledoc']), @published_at)

            @restored_post = nil
        end

        def load_restored_post
            self.restored_post = RestoredPost.find_by(original_post_uuid: self.uuid)
        end

        class Mobiledoc
            attr_reader :cards

            def initialize(json, post_published_at)
                @cards = json['cards'].map {|card_json| Card.create(card_json, post_published_at) }
            end

            class Card
                def initialize(json, post_published_at)
                    @post_published_at = post_published_at
                end

                def self.create(json, post_published_at)
                    # pp json

                    case json[0]
                    when 'image'
                      ImageCard.new(json[1], post_published_at)
                    when 'gallery'
                        GalleryCard.new(json[1], post_published_at)
                    when 'video'
                        VideoCard.new(json[1], post_published_at)
                    else
                      raise "Unknown card type: #{json[0]}"
                    end
                end

                def eligible_media_files
                    raise "Unsupported"
                end

                def expected_media_files_count
                    raise "Unsupported"
                end
            end

            class ImageCard < Card
                attr_reader :src

                def initialize(json, post_published_at)
                    super(json, post_published_at)

                    @src = json['src']
                end

                def eligible_media_files(days_range)
                    MediaFile.where(kind: 'image', created_at: (@post_published_at - days_range.day)..(@post_published_at + days_range.day)).order(created_at: :asc)
                end

                def expected_media_files_count
                    1
                end
            end

            class GalleryCard < Card
                attr_reader :images

                def initialize(json, post_published_at)
                    super(json, post_published_at)

                    @images = json['images'].map {|image_json| Image.new(image_json) }
                end

                def eligible_media_files(days_range)
                    MediaFile.where(kind: 'image', created_at: (@post_published_at - days_range.day)..(@post_published_at + days_range.day)).order(created_at: :asc)
                end

                def expected_media_files_count
                    @images.count
                end

                class Image
                    def initialize(json)
                    end
                end
            end

            class VideoCard < Card
                attr_reader :src
                attr_reader :caption

                def initialize(json, post_published_at)
                    super(json, post_published_at)

                    @src = json['src']
                    @caption = json['caption']
                end

                def eligible_media_files(days_range)
                    MediaFile.where(kind: 'video', created_at: (@post_published_at - days_range.day)..(@post_published_at + days_range.day)).order(created_at: :asc)
                end

                def expected_media_files_count
                    1
                end
            end
        end
    end
end

Rails.application.config.ghost = Ghost.new(file)
