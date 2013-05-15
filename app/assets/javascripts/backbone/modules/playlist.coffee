Zinc.App.module "Playlist", (Playlist, App) ->
  @startWithParent = false

  class Video extends Backbone.Model
  class VideosCollection extends Backbone.Collection
    model: Video

  class PlayListItem extends Backbone.Marionette.ItemView
    tagName: "li"
    template: "playlist/video"
    templateHelpers:
      current_user: -> App.current_user
    events:
      "click .remove": "video_remove"

    video_remove: (e) ->
      App.Socket.do "video_remove",
        video_id: @model.get "id"

  class PlayListView extends Backbone.Marionette.CollectionView
    itemView: PlayListItem
    el: ".play-list"


  @addInitializer =>
    App.vent.trigger "init:", @moduleName, arguments
    App.execute "handle", ["video_add", "video_remove", "videos_update"]

    @videos_collection = new VideosCollection App.options.videos

    App.vent.on "videos_update", (videos) =>
      @videos_collection.reset videos

    @play_list_view = new PlayListView
      collection: @videos_collection
    @play_list_view.render()

    App.current_user.on "change:roles", =>
      @play_list_view.render()

  @addFinalizer =>
    App.vent.trigger "bye:", @moduleName, arguments
