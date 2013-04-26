WebsocketRails.setup do |config|

  config.log_level = :debug
  config.standalone = false
  config.synchronize = false

end

WebsocketRails::EventMap.describe do

  subscribe :client_connected_to_channel,      :to => ChatController, :with_method => :client_connected_to_channel
  subscribe :client_disconnected_from_channel, :to => ChatController, :with_method => :client_disconnected_from_channel
  subscribe :new_message,                      :to => ChatController, :with_method => :new_message

end
