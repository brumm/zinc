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
      secondsToHms: (d) ->
        d = Number(d)
        h = Math.floor(d / 3600)
        m = Math.floor(d % 3600 / 60)
        s = Math.floor(d % 3600 % 60)
        ((if h > 0 then h + ":" else "")) + ((if m > 0 then ((if h > 0 and m < 10 then "0" else "")) + m + ":" else "0:")) + ((if s < 10 then "0" else "")) + s

    events:
      "click .remove": "video_remove"

    video_remove: (e) ->
      App.Room.do "video_remove",
        video_id: @model.get "id"

  class PlayListView extends Backbone.Marionette.CollectionView
    itemView: PlayListItem
    el: ".play-list"


  @addInitializer =>
    App.vent.trigger "init:", @moduleName, arguments
    App.execute "handle", ["video_add", "video_remove", "videos_update", "video_sync", "video_skip"]

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
