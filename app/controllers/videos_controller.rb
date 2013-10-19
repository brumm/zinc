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

    return unless current_user and (current_user.is?(:owner, room) or current_user.has_role?(:admin))

    video = room.videos.find(video_id).destroy

    if video
      WebsocketRails[room_name].trigger(:video_remove, {
        video: video.as_json,
        user: user
      })
      broadcast_video_list room_name, room.videos
    end
  end

  def video_mark_seen
    # fail fast
    return unless current_user

    room_name = data[:room]
    video_id  = data[:video_id]
    room      = Room.friendly.find room_name

    room.videos.find(video_id).touch(:ended_at)

    WebsocketRails[room_name].trigger(:video_skip, room.videos.first.external_id)
    broadcast_video_list room_name, room.videos
  end

  def video_sync
    # fail fast
    return unless current_user # && current_user.is?(:owner, room) || current_user.is?(:mod, room)

    room_name = data[:room]
    timestamp = data[:timestamp]

    WebsocketRails[room_name].trigger(:video_sync, timestamp)
  end

  private

  def broadcast_video_list room_name, videos
    WebsocketRails[room_name].trigger(:videos_update, videos)
  end


end
