Zinc.App.module "Chat", (Chat, App) ->
  @startWithParent = false

  class ChatView extends Backbone.View
    el: ".chat-container"
    events:
      'keydown #send-message': 'send_message'

    send_message: (e) ->
      $target = $(e.target)
      message = $target.val()

      # if !current_user
      #  window.location = Routes.login_path(room: App.Room.name)
      # enter
      if e.which is 13 and message
        App.Socket.do "user_message",
          message: message
          room: App.Room.name
        @last_message = message
        $target.val("")

      # arrow up
      if e.which is 38
        $target.val(@last_message)

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
