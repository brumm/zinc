Zinc.App.module "Chat", (Chat, App) ->
  @startWithParent = false

  class ChatView extends Backbone.View
    el: ".chat-container"
    events:
      'keydown #send-message': 'send_message'
      'click': 'focus_send_message'

    initialize: ->
      @$chat_list = @$el.find(".chat-list")

    add_message: (template, data) ->
      @$chat_list.append App.tmpl template, data
      scrollHeight = @$chat_list[0].scrollHeight
      @$chat_list.scrollTop(scrollHeight)

    focus_send_message: (e) ->
      @$el.find("#send-message").focus()

    send_message: (e) ->
      $target = $(e.target)
      message = $target.val().replace(/^\s+|\s+$/g, "")

      # enter and message
      if e.which is 13 and message.length
        unless App.current_user.is_logged_in()
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
      @chat_view.add_message "chat/joined", user

    App.vent.on "user_leave", (user) =>
      @chat_view.add_message "chat/left", user

    App.vent.on "video_add", (data) =>
      @chat_view.add_message "chat/added_video", data

    App.vent.on "video_remove", (data) =>
      @chat_view.add_message "chat/removed_video", data

    App.vent.on "user_message", (data) =>
      if !App.current_user.isNew() && App.current_user.get("name") isnt data.user.name
        name_regex = RegExp App.current_user.get("name")
        data.type = if name_regex.test data.message then "mention" else ""

      @chat_view.add_message "chat/message", data

  @addFinalizer =>
    App.vent.trigger "bye:", @moduleName, arguments
