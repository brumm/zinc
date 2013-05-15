#= require jquery
#= require jquery_ujs

#= require hamlcoffee
#= require js-routes
#= require_tree ./templates

#= require websocket_rails/main

#= require underscore-min
#= require backbone-min
#= require backbone.marionette
#= require jquery.typing-0.3.0.min

#= require Zinc
#= require_tree ./backbone/modules
#= require_tree ./lib

$ ->
  $(document).on "click", "[data-toggle]", ->
    $(@).toggleClass $(@).data("toggle") || "toggle"

  $('[data-typing]').typing
    start: (event, $elem) -> $elem.trigger "typing:start"
    stop:  (event, $elem) -> $elem.trigger "typing:stop"
    delay: 400

  # start with options
  Zinc.App.start _.extend Zinc.global, Zinc.config
