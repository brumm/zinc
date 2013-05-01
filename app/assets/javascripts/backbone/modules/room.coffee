Zinc.App.module "Room", (Room, App) ->
  @startWithParent = false

  @addInitializer =>
    console.log "init:", @moduleName, arguments
    App.Socket.start()

    App.vent.on "socket_connected", =>
      $(".chat-container").removeClass "busy"
      App.Chat.start()

  @addFinalizer =>
    console.log "bye:", @moduleName, arguments
