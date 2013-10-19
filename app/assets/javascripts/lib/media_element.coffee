class Zinc.MediaElement
  callbacks: {}
  isPaused = false

  constructor: (element, options = {}) ->

    @on "play", =>
      @ticker = window.setInterval (=> @do "tick", @currentTime()), 500
    @on "pause", =>
      window.clearInterval @ticker
    @on "end", =>
      window.clearInterval @ticker

    @_attachYoutubeHandler(element, options.external_id)

    tag = document.createElement('script')
    tag.src = "https://www.youtube.com/iframe_api"
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

  mute:             -> @player.mute()
  currentTime:      -> @player.getCurrentTime()
  duration:         -> @player.getDuration()
  play:             -> @player.playVideo()
  stop:             -> @player.stopVideo()
  pause:            -> @player.pauseVideo()
  togglePlayback:   ->
                       @isPaused = !@isPaused
                       console.log @isPaused
                       if @isPaused then @play() else @pause()
  loaded:           -> @player.getVideoLoadedFraction()
  seekTo: (seconds) -> @player.seekTo(seconds)
  load: (id)        -> @player.loadVideoById(id, 0, "large")

  on: (event, callback) =>
    @callbacks[event] or= []
    @callbacks[event].push callback

  do: (event, data = {}) ->
    if @callbacks[event]?
      callback?.call @, data for callback in @callbacks[event]

  _attachYoutubeHandler: (element, external_id) ->
    window.onYouTubeIframeAPIReady = =>
      @player = new YT.Player element,
        playerVars:
          controls: 0
        videoId: external_id || null
        events:
          onReady: (event) => @do "ready", event
          onError: =>
            reason = switch event.data
              when 2 then "invalid_param"
              when 5 then "html5_player_problem"
              when 100 then "video_not_found"
              when 101 or 150 then "video_embed_denied"
            @do "error", reason

          onStateChange: (event) =>
            state = switch event.data
              when YT.PlayerState.BUFFERING then "buffer"
              when YT.PlayerState.PLAYING then "play"
              when YT.PlayerState.PAUSED then "pause"
              when YT.PlayerState.ENDED then "end"
              when YT.PlayerState.CUED then "cue"

            @do state, event
