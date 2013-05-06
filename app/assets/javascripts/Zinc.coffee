
# hook up JST to Marionette
Backbone.Marionette.Renderer.render = (template, data) ->
  throw "Template #{template} not found!" unless JST[template]
  JST[template](data)

Zinc.App = new Backbone.Marionette.Application()

Zinc.App.addInitializer (options) ->

  @tmpl = (template, data) ->
    Backbone.Marionette.Renderer.render template, data

  class User extends Backbone.Model
  class UsersCollection extends Backbone.Collection
    model: User

  @current_user     = if options.user? then new User options.user else options.user
  @users_collection = new UsersCollection

  @vent.on "users_update", (users) =>
    @users_collection.reset users

  # start notifications
  @module("Notifications").start(options.debug)

  # start our 'controller' module with action
  @module(options.controller).start(options.action)

  # since there's no App.stop() method,
  # we'll do it the hard way
  $(window).unload =>
    console.log "window:unload"
    for name, module of @submodules
      console.log "stopping:", name
      module.stop()
