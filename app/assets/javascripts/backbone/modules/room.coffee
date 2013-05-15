Zinc.App.module "Room", (Room, App) ->
  @startWithParent = false

  App.vent.on "socket_connected", =>
    App.Socket.subscribe @name
    App.Socket.do "user_join"

    App.Chat.start()
    App.Userlist.start()
    App.Playlist.start()
    App.SearchBox.start()

  @actions =
    show: =>
      App.Socket.start()
      @name = App.options.room

  @addInitializer (action) =>
    App.vent.trigger "init:", @moduleName, arguments
    @actions[action]?()

  @addFinalizer =>
    App.vent.trigger "bye:", @moduleName, arguments
    App.Socket.do "user_leave"
