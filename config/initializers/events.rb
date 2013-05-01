WebsocketRails.setup do |config|

  config.log_level = :debug
  config.standalone = false
  config.synchronize = false

end

WebsocketRails::EventMap.describe do

  subscribe :user_join,    to: ChatController, with_method: :user_join
  subscribe :user_leave,   to: ChatController, with_method: :user_leave
  subscribe :user_message, to: ChatController, with_method: :user_message

end
