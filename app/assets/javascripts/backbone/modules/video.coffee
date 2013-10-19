Zinc.App.module "Video", (Video, App) ->
  @startWithParent = false

  class VideoOverlayView extends Backbone.Marionette.ItemView
    el: ".video-overlay"
    template: "video/overlay"
    modelEvents:
      "change": "render"
    events:
      "click": "toggle"

    toggle: -> @options.player.togglePlayback()

  @addInitializer =>
    # @view.render()
    App.vent.trigger "init:", @moduleName, arguments

    if App.Playlist.videos_collection.length

      @media = new Zinc.MediaElement "video-player",
        external_id: App.Playlist.videos_collection.first().get("external_id")

      @view = new VideoOverlayView
        model: App.Playlist.videos_collection.first()
        player: @media
      @view.render()

      @media.on 'ready', (time) => @media.play()

      @media.on 'tick', (time) =>
        if App.current_user.is_role("mod", "owner") and time % 3
          App.Room.do "video_sync",
            timestamp: @media.currentTime()

        @view.model.set
          playback: (time / @media.duration()) * 100
          loaded: @media.loaded() * 100

      @media.on 'end', ->
        App.Room.do "video_mark_seen",
          video_id: App.Playlist.videos_collection.first().get("id")

      # App.Playlist.videos_collection.on "reset", (collection, old_collection) =>
      #   if collection.length and old_collection?.previousModels[0]?.attributes?.external_id? isnt collection.first().get("external_id")
      #     @view.model.set(collection.first().toJSON())
      #     @media.load(collection.first().get("external_id"))
      #     @media.play()

      App.vent.on "video_sync", (timestamp) =>
        if !@media.isPaused and Math.abs(@media.currentTime() - timestamp) > 3
          @media.seekTo timestamp
