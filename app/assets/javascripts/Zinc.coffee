
# hook up JST to Marionette
Backbone.Marionette.Renderer.render = (template, data) ->
  throw "Template #{template} not found!" unless JST[template]
  JST[template](data)

Zinc.App = new Backbone.Marionette.Application()

Zinc.App.addInitializer (@options) ->

  # quick access to templating
  @tmpl = (template, data) ->
    Backbone.Marionette.Renderer.render template, data

  # create user
  @module("User").start(@options.user)

  # start notifications
  @module("Notifications").start(@options.debug)

  # start our 'controller' module with action
  @module(@options.controller).start(@options.action)

  # since there's no App.stop() method,
  # we'll do it the hard way
  $(window).unload =>
    console.log "window:unload"
    for name, module of @submodules
      console.log "stopping:", name
      module.stop()
