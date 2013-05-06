Zinc.App.module "Notifications", (Notifications, App) ->
  @startWithParent = false

  @addInitializer (debug) =>
    App.vent.trigger "init:", @moduleName, arguments

    @notifier = new Zinc.Browl

    if debug
      # hook up error reporting
      window.onerror = (message, line) =>
        @notifier.notify "error",
          title: message
          message: line

      # hook up event reporting
      App.vent.on "all", (event, data) =>
        console.log "event:", event, if data? then data else ""
        @notifier.notify "event",
          title: event
          message: JSON.stringify data, undefined, 2

  @notify = ->
    @notifier.notifier arguments

  @addFinalizer =>
    App.vent.trigger "bye:", @moduleName, arguments
