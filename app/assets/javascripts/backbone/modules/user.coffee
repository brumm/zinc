Zinc.App.module "User", (User, App) ->
  @startWithParent = false

  class User extends Backbone.Model
    is_role: (role) ->
      _.contains @get("roles"), role
    is_logged_in: -> !!@get("id")

    make_mod: ->
      App.Room.do "user_change_role",
        role: "mod"
        action: "add"
        user_id: @get("id")

    de_mod: ->
      App.Room.do "user_change_role",
        role: "mod"
        action: "remove"
        user_id: @get("id")

  class UsersCollection extends Backbone.Collection
    model: User
    comparator: (user) -> user.get("name")

  @addInitializer (user_data) =>
    App.vent.trigger "init:", @moduleName, arguments

    App.current_user     = new User user_data
    App.users_collection = new UsersCollection

    App.vent.on "users_update", (users) =>
      # TODO: should the current user be set by the server?
      current_user = user for user in users when user.id is App.current_user.get("id")
      App.current_user.set current_user

      App.users_collection.set users

  @addFinalizer =>
    App.vent.trigger "bye:", @moduleName, arguments
