class Zinc.Room
  constructor: (@name) ->
    @socket  = new WebSocketRails "#{location.host}/websocket"
    @channel = @socket.subscribe @name
    @events  = {}

    # announce user
    on_create.call @
    # catch beforeunload to destroy
    $(window).on "beforeunload", => on_destroy.call @; null # explicitly return null so the window can close

  on: (event, callback) ->
    @events[event] or= $.Callbacks()
    @events[event].add callback

    if event is "open"
      @socket["on_open"] = =>
        @events[event].fire(arguments[0])
    else
      @channel.bind event, =>
        @events[event].fire(arguments[0])

  do: (event, object) ->
    object.room = @name
    @socket.trigger event, object

  on_create = ->
    @socket.trigger "client_connected_to_channel", room: @name

  on_destroy = ->
    @socket.trigger "client_disconnected_from_channel", room: @name
