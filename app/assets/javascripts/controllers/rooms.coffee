
Zinc.controllers =
  rooms:
    show: ->
      @room = new Zinc.Room Zinc.room
      $chat = $(".chat-container .chat")

      @room.on "open", -> $chat.parent().removeClass "busy"

      @room.on "client_connected_to_channel", (response) ->
        $chat.append("<li class='status'>#{response.user.name} joined the chat</li>")

      @room.on "client_disconnected_from_channel", (response) ->
        $chat.append("<li class='status'>#{response.user.name} left the chat</li>")

      @room.on "user_list", (response) ->
        console.log "userlist:", response

      @room.on "new_message", (response) ->
        $chat.append("<li><span class='name'>#{response.user.name}</span><span class='message'>#{response.message}</span></li>")
        scrollHeight = $chat[0].scrollHeight
        $chat.scrollTop(scrollHeight)

      $("#send-message").on "keydown", (e) =>
        if e.which is 38
          $(e.target).val(@last_message)

        if e.which is 13
          @last_message = message = @escape_message $(e.target).val()
          @room.do "new_message",
            message: message
          $(e.target).val("")

    escape_message: (message) ->
      $("<div></div>").text(message).html()
