module PostsHelper
    def media_file_url_for(media_file)
        "http://Dobby.local:8888/#{media_file.path.sub('/Volumes/BACKUP_TRAVEL/Media/Personal/','')}"
    end

    def media_file_tag_for(media_file)
        if media_file.kind == 'image'
            image_tag(media_file_url_for(media_file), title: "#{media_file.path} - #{media_file.created_at}")
        elsif media_file.kind == 'video'
            video_tag(media_file_url_for(media_file), title: "#{media_file.path} - #{media_file.created_at}")
        else
            raise 'Unsupported #{media_file.kind}'
        end
    end
end