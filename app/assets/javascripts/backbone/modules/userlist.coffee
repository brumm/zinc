Zinc.App.module "Userlist", (Userlist, App) ->
  @startWithParent = false

  class UserListItem extends Backbone.Marionette.ItemView
    tagName: "li"
    template: "userlist/user"
    className: => @model.get("roles")

  class UserListView extends Backbone.Marionette.CollectionView
    itemView: UserListItem
    el: ".user-list"

  @addInitializer =>
    App.vent.trigger "init:", @moduleName, arguments

    App.execute "handle", ["users_update"]

    @user_list_view = new UserListView
      collection: App.users_collection

  @addFinalizer =>
    App.vent.trigger "bye:", @moduleName, arguments
