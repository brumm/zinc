Zinc.App.module "Chat", (Chat, App) ->
  @startWithParent = false

  class ChatView extends Backbone.View
    el: ".chat-container"
    events:
      'keydown #send-message': 'send_message'

    send_message: (e) ->
      if e.which is 13
        App.Socket.socket.trigger "user_message",
          message: $(e.target).val()
          room: Zinc.room
        $(e.target).val("")

  @addInitializer =>
    console.log "init:", @moduleName, arguments

    $(".chat-container").removeClass "busy"

    @chat_view = new ChatView
    App.execute "handle", ["user_message", "user_join", "user_leave"]

    App.vent.on "user_join", (user) =>
      @chat_view.$chat_list.append App.tmpl("chat/joined", user)

    App.vent.on "user_leave", (user) =>
      @chat_view.$chat_list.append App.tmpl("chat/left", user)

    App.vent.on "user_message", (data) =>
      scrollHeight = @chat_view.$el.find(".chat-list")[0].scrollHeight
      @chat_view.$el.find(".chat-list").scrollTop(scrollHeight)

      @chat_view.$chat_list.append App.tmpl("chat/message", data)

  @addFinalizer =>
    console.log "bye:", @moduleName, arguments
