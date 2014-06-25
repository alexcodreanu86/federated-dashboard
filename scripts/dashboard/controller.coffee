namespace('Dashboard')

class Dashboard.Controller
  @bind: ->
    $('[data-id=pictures-widget]').click(=> @setupWidget(Pictures.Controller, 'a48194703ae0d0d1055d6ded6c4c9869'))
    $('[data-id=weather-widget]').click(=> @setupWidget(Weather.Controller, '12ba191e2fec98ad'))
    $('[data-id=stock-widget]').click( =>  @setupWidget(Stock.Controller, null))
    $('[data-id=twitter-widget]').click( => @loadForm('twitter', Twitter.Controller))
    $('[data-id=menu-button]').click( => @toggleSidenav())

  @unbind: ->
    $('[data-id=pictures-widget]').unbind('click')
    $('[data-id=weather-widget]').unbind('click')
    $('[data-id=stock-widget]').unbind('click')
    $('[data-id=twitter-widget]').unbind('click')
    $('[data-id=menu-button]').unbind('click')

  @rebind: ->
    @unbind()
    @bind()

  @loadForm: (widget, controller) ->
    form = Dashboard.Display.generateForm(widget)
    Dashboard.Display.populateWidget(form)
    controller.bind()

  @setupWidget: (controller, apiKey)->
    controller.setupWidgetIn('[data-id=widget-display]', apiKey)

  @toggleSidenav: ->
    if Dashboard.Display.isSidenavDisplayed()
      Dashboard.Display.removeSidenav()
    else
      Dashboard.Display.showSidenav()
    @rebind()
