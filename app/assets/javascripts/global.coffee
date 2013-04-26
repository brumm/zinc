
$ ->

  controller = Zinc.global.controller
  action     = Zinc.global.action

  if Zinc.controllers[controller] and Zinc.controllers[controller][action]
    method   = Zinc.controllers[controller][action]
    if $.isFunction method
      console.log "#{controller}##{action}"
      method.apply(Zinc.controllers[controller])
