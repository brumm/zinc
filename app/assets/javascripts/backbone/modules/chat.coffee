Zinc.App.module "Chat", (Chat, App) ->
  @startWithParent = false

  class ChatView extends Backbone.View
    el: ".chat-container"
    events:
      'keydown #send-message': 'send_message'

    initialize: ->
      @$chat_list = @$el.find(".chat-list")

    send_message: (e) ->
      $target = $(e.target)
      message = $target.val()

      # enter and message
      if e.which is 13 and message
        unless App.current_user?
         window.location = Routes.login_path()
        else
          App.Room.do "user_message",
            message: message
          @last_message = message
          $target.val("")

      # arrow up
      if e.which is 38
        $target.val(@last_message)

  @addInitializer =>
    App.vent.trigger "init:", @moduleName, arguments

    @chat_view = new ChatView
    @chat_view.$el.removeClass "busy"
    App.execute "handle", ["user_message", "user_join", "user_leave"]

    App.vent.on "user_join", (user) =>
      @chat_view.$chat_list.append App.tmpl("chat/joined", user)

    App.vent.on "user_leave", (user) =>
      @chat_view.$chat_list.append App.tmpl("chat/left", user)

    App.vent.on "video_add", (data) =>
      @chat_view.$chat_list.append App.tmpl("chat/added_video", data)

    App.vent.on "video_remove", (data) =>
      @chat_view.$chat_list.append App.tmpl("chat/removed_video", data)

    App.vent.on "user_message", (data) =>
      if App.current_user.get("name") isnt data.user.name
        name_regex = RegExp App.current_user.get("name")
        data.type = if name_regex.test data.message then "mention" else ""

      @chat_view.$chat_list.append App.tmpl("chat/message", data)
      scrollHeight = @chat_view.$chat_list[0].scrollHeight
      @chat_view.$chat_list.scrollTop(scrollHeight)

  @addFinalizer =>
    App.vent.trigger "bye:", @moduleName, arguments
