class ChatsController < WebsocketRails::BaseController

  def user_join
    # fail fast
    return unless current_user

    room_name = data[:room]
    room = Room.friendly.find room_name
    user = current_user.as_json(resource: room)

    users_list(room_name)[user[:id]] = user

    WebsocketRails[room_name].trigger(:user_join, {
      user: user
    })
    broadcast_user_list room_name
  end

  def user_leave
    # fail fast
    return unless current_user

    room_name = data[:room]
    room = Room.friendly.find room_name
    user = current_user.as_json(resource: room)

    users_list(room_name).delete user[:id]

    WebsocketRails[room_name].trigger(:user_leave, {
      user: user
    })
    broadcast_user_list room_name
  end

  def user_message
    # fail fast
    return unless current_user

    room_name    = data[:room]
    chat_message = data[:message]

    WebsocketRails[room_name].trigger(:user_message, {
      user: current_user.as_json,
      message: chat_message
    })
  end

  def user_change_role
    room_name         = data[:room]
    role              = data[:role]
    action            = data[:action]
    room      = Room.friendly.find room_name

    return unless current_user and (current_user.is?(:owner, room) or current_user.has_role?(:admin))

    user = User.find data[:user_id]

    if action == "remove"
      user.remove_role(role, room)
    elsif action == "add"
      user.add_role(role, room)
    end

    user = user.as_json(resource: room)
    users_list(room_name)[user[:id]] = user

    broadcast_user_list room_name
  end

  private

  def broadcast_user_list room_name
    WebsocketRails[room_name].trigger(:users_update, users_list(room_name).values)
  end

  def users_list room_name
    controller_store[room_name] ||= {}
    controller_store[room_name]
  end

end
