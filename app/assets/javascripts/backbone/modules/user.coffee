Zinc.App.module "User", (User, App) ->
  @startWithParent = false

  class User extends Backbone.Model
    is_role: (role) ->
      _.contains @get("roles"), role

    # make_mod: ->
    #   App.Socket.do "user_make_mod",
    #     user_id: @get("id")

  class UsersCollection extends Backbone.Collection
    model: User
    comparator: (user) -> user.get("name")

  @addInitializer (user_data) =>
    App.vent.trigger "init:", @moduleName, arguments

    App.current_user     = if user_data? then new User user_data else user_data
    App.users_collection = new UsersCollection

    App.vent.on "users_update", (users) =>
      App.users_collection.reset users

  @addFinalizer =>
    App.vent.trigger "bye:", @moduleName, arguments
