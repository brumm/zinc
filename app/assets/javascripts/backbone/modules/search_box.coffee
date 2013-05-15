Zinc.App.module "SearchBox", (SearchBox, App) ->
  @startWithParent = false

  class Result extends Backbone.Model
  class ResultsCollection extends Backbone.Collection
    model: Result
    url: "http://gdata.youtube.com/feeds/api/videos"

    parse: (response) =>
      if response.feed.entry?
        for entry in response.feed.entry
          title: entry.title.$t
          thumbnail: entry.media$group.media$thumbnail[0].url
          url: entry.link[0].href.replace("&feature=youtube_gdata", "")

    search: (term) ->
      @fetch
        data:
          alt: "json"
          "max-results": 10
          q: term
        reset: true


  class ResultListItemView extends Backbone.Marionette.ItemView
    tagName: "li"
    template: "search_box/result"
    events:
      "click": "select"

    select: ->
      App.Socket.do "video_add",
        url: @model.get("url")

      $("#add-video").val("")
      $(".search-results-list").empty()


  class ResultListView extends Backbone.Marionette.CollectionView
    itemView: ResultListItemView
    el: ".search-results-list"
    events:
      "scroll": "scroll"

    # scroll: (e) ->
    #   space_left = @el.scrollHeight - (@$el.scrollTop() + @$el.height())
    #   if space_left <= 20
    #     $("#add-video").trigger("typing:stop")


  class SearchBoxView extends Backbone.View
    events:
      'typing:stop #add-video': 'search'
      'keyup #add-video': 'enter'

    el: ".playlist-container"

    initialize: ->
      @result_collection = new ResultsCollection
      @result_list_view = new ResultListView
        collection: @result_collection
      @result_list_view.render()

    enter: (e) ->
      if e.which is 13
        App.Socket.do "video_add",
          url: e.target.value
        $("#add-video").val("")
        $(".search-results-list").empty()

    search: (e) ->
      if e.target.value
        @result_collection.search(e.target.value)
      else
        @result_collection.reset()

  @addInitializer (action) =>
    App.vent.trigger "init:", @moduleName, arguments

    # doesnt render anything, just listens to events
    @video_box_view = new SearchBoxView()
