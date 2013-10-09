class VideosController < WebsocketRails::BaseController

  def video_add
    # fail fast
    return unless current_user

    room_name = data[:room]
    room      = Room.friendly.find room_name
    user      = current_user.as_json(resource: room)

    video = room.videos.build( url: data[:url] )

    if video.save
      WebsocketRails[room_name].trigger(:video_add, {
        video: video.as_json,
        user: user
      })
      broadcast_video_list room_name, room.videos
    end
  end

  def video_remove
    # fail fast
    return unless current_user

    room_name = data[:room]
    video_id  = data[:video_id]
    room      = Room.friendly.find room_name
    user      = current_user.as_json(resource: room)

    video = room.videos.find(video_id).destroy

    if video
      WebsocketRails[room_name].trigger(:video_remove, {
        video: video.as_json,
        user: user
      })
      broadcast_video_list room_name, room.videos
    end
  end

  private

  def broadcast_video_list room_name, videos
    WebsocketRails[room_name].trigger(:videos_update, videos)
  end


end
