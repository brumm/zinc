class ChatController < WebsocketRails::BaseController

  def client_connected_to_channel
    return unless current_user

    room = message[:room]
    user_list(room) << current_user.as_json

    WebsocketRails[room].trigger(:client_connected_to_channel, {
      user: current_user.as_json
    })

    broadcast_user_list room
  end

  def client_disconnected_from_channel
    return unless current_user

    room = message[:room]
    user_list(room).delete current_user.as_json

    WebsocketRails[room].trigger(:client_disconnected_from_channel, {
      user: current_user.as_json
    })

    broadcast_user_list room
  end

  def new_message
    return unless current_user

    room         = message[:room]
    chat_message = message[:message]

    WebsocketRails[room].trigger(:new_message, {
      user: current_user.as_json,
      message: chat_message
    })
  end

  private

  def broadcast_user_list room
    WebsocketRails[room].trigger(:user_list, user_list(room))
  end

  def user_list room
    controller_store[room] ||= []
  end

end
