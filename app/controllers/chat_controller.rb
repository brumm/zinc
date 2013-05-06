class ChatController < WebsocketRails::BaseController

  def user_join
    # fail fast
    return unless current_user

    room = data[:room]
    room_model = Room.find room
    user = current_user.as_json(resource: room_model)

    users_list(room) << user

    WebsocketRails[room].trigger(:user_join, {
      user: user
    })
    broadcast_user_list room
  end

  def user_leave
    # fail fast
    return unless current_user

    room = data[:room]
    room_model = Room.find room
    user = current_user.as_json(resource: room_model)

    users_list(room).delete user

    WebsocketRails[room].trigger(:user_leave, {
      user: user
    })
    broadcast_user_list room
  end

  def user_message
    # fail fast
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
