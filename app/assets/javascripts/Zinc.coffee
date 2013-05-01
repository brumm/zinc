
Backbone.Marionette.Renderer.render = (template, data) ->
  throw "Template #{template} not found!" unless JST[template]
  JST[template](data)

Zinc.App = new Backbone.Marionette.Application()

Zinc.App.addInitializer (options) ->

  @vent.on "all", (event, data) ->
    console.log "event:", event, if data? then data else ""

  @module(options.controller).start(options.action)

  $(window).unload =>
    console.log "window:unload"
    for name, module of @submodules
      console.log "stopping:", name
      module.stop()
