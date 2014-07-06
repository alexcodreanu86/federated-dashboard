namespace('Dashboard.Sidenav')

class Dashboard.Sidenav.Controller
  @initialize: ->
    @bindButtons()
    Dashboard.Widgets.Controller.enterEditMode()

  @bindButtons: ->
    $('[data-id=pictures-widget]').click(=> Dashboard.Widgets.Controller.checkWidget("pictures"))
    $('[data-id=weather-widget]').click(=> Dashboard.Widgets.Controller.checkWidget("weather"))
    $('[data-id=stock-widget]').click( =>  Dashboard.Widgets.Controller.checkWidget("stock"))
    $('[data-id=twitter-widget]').click( => Dashboard.Widgets.Controller.checkWidget("twitter"))

  @unbind: ->
    $('[data-id=pictures-widget]').unbind('click')
    $('[data-id=weather-widget]').unbind('click')
    $('[data-id=stock-widget]').unbind('click')
    $('[data-id=twitter-widget]').unbind('click')

