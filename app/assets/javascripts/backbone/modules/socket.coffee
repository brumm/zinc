Zinc.App.module "Socket", (Socket, App) ->

  @startWithParent = false

  handle = (event) =>
    @channel.bind event, ->
      App.vent.trigger event, arguments[0]

  App.commands.setHandler "handle", (events) =>
    handle event for event in events

  @addInitializer =>
    console.log "init:", @moduleName, arguments

    @socket         = new WebSocketRails "#{location.host}/websocket"
    @channel        = @socket.subscribe Zinc.room
    @socket.on_open = -> App.vent.trigger "socket_connected", arguments
