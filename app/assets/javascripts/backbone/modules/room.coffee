Zinc.App.module "Room", (Room, App) ->
  @startWithParent = false

  App.vent.on "socket_connected", =>
    App.Socket.subscribe @name
    App.Socket.do "user_join", room: @name

    App.Chat.start()
    App.Userlist.start()

  @actions =
    show: =>
      App.Socket.start()
      @name = App.options.room

  @addInitializer (action) =>
    App.vent.trigger "init:", @moduleName, arguments
    @actions[action]?()

  @addFinalizer =>
    App.vent.trigger "bye:", @moduleName, arguments
    App.Socket.do "user_leave", room: @name
