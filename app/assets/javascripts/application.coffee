#= require jquery
#= require jquery_ujs

#= require hamlcoffee
#= require_tree ./templates

#= require websocket_rails/main

#= require backbone-rails
#= require backbone.marionette

#= require Zinc
#= require_tree ./backbone/modules
#= require_tree ./lib

$ ->
  $(document).on "click", "[data-toggle]", -> $(@).toggleClass $(@).data("toggle") || "toggle"

  Zinc.App.start
    controller: Zinc.global.controller
    action: Zinc.global.action
