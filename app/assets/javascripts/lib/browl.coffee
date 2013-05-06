class Zinc.Browl
  defaults =
    container:
      class: ".browl-container"
      position: "top-right"
    notification:
      class: ".browl-notification"
      timeout_delay: 5000
      template: (type, data) ->
        JST["notifications/#{type}"](data) if JST["notifications/#{type}"]

  constructor: ->
    @$container    = $(defaults.container.class).addClass defaults.container.position

  remove = ($notification) ->
    $notification.on "webkitTransitionEnd transitionend", ->
      $notification.remove()

    $notification.css
      opacity: 0
      marginTop: -$notification.outerHeight(true)

  notify: (type, data) =>
    $template      = $ defaults.notification.template(type, data)
    $notification  = $template.appendTo @$container

    $notification.click ->
      remove($notification)

    @$container.width @$container.width()
    $notification.removeClass "out"

    setTimeout ->
        remove($notification)
    , defaults.notification.timeout_delay
