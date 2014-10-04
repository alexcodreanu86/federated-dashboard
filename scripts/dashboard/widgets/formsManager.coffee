namespace('Dashboard.Widgets')

class Dashboard.Widgets.FormsManager
  constructor: (animationSpeed) ->
    @animationSpeed = animationSpeed

  exitEditMode: ->
    $('[data-name=widget-form]').hide(@animationSpeed)
    $('[data-name=widget-close]').hide(@animationSpeed)

  enterEditMode: ->
    $('[data-name=widget-form]').show(@animationSpeed)
    $('[data-name=widget-close]').show(@animationSpeed)
