class ChatController < WebsocketRails::BaseController

  def user_join
    return unless current_user

    room = data[:room]
    users_list(room) << current_user.as_json

    WebsocketRails[room].trigger(:user_join, {
      user: current_user.as_json
    })
    broadcast_user_list room
  end

  def user_leave
    return unless current_user

    room = data[:room]
    users_list(room).delete current_user.as_json

    WebsocketRails[room].trigger(:user_leave, {
      user: current_user.as_json
    })
    broadcast_user_list room
  end

  def user_message
    return unless current_user

    room         = data[:room]
    chat_message = data[:message]

    WebsocketRails[room].trigger(:user_message, {
      user: current_user.as_json,
      message: chat_message
    })
  end

  private

  def broadcast_user_list room
    WebsocketRails[room].trigger(:users_update, users_list(room))
  end

  def users_list room
    controller_store[room] ||= []
    controller_store[room]
  end

end
