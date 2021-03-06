WebsocketRails.setup do |config|

  config.log_level = :debug
  config.standalone = false
  config.synchronize = false

end

WebsocketRails::EventMap.describe do

  subscribe :user_join,           to: ChatsController, with_method: :user_join
  subscribe :user_leave,          to: ChatsController, with_method: :user_leave
  subscribe :user_message,        to: ChatsController, with_method: :user_message
  subscribe :user_change_role,    to: ChatsController, with_method: :user_change_role

  subscribe :video_add,           to: VideosController, with_method: :video_add
  subscribe :video_remove,        to: VideosController, with_method: :video_remove
  subscribe :video_mark_seen,     to: VideosController, with_method: :video_mark_seen
  subscribe :video_sync,          to: VideosController, with_method: :video_sync

end
