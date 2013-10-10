Zinc.App.module "Socket", (Socket, App) ->

  @startWithParent = false

  handle = (event) =>
    @channel.bind event, ->
      App.vent.trigger event, arguments[0]

  App.commands.setHandler "handle", (events) =>
    handle event for event in events

  @addInitializer =>
    App.vent.trigger "init:", @moduleName, arguments

    @socket          = new WebSocketRails "#{location.host}/websocket"
    @socket.on_open  = -> App.vent.trigger "socket_connected", arguments
    @socket.on_close = -> App.vent.trigger "socket_disconnected", arguments
    @socket.on_error = -> App.vent.trigger "socket_error", arguments

  @on = (event, callback) ->
    @channel.bind event, callback

  @do = (event, data = {}) ->
    @socket.trigger event, data

  @subscribe = (channel) ->
    @channel = @socket.subscribe channel
