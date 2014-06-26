namespace('Dashboard')

class Dashboard.Controller
  @initialize: ->
    @bind()
    @generateWrappedWidgets()

  @bind: ->
    $('[data-id=pictures-widget]').click(=> @checkWidget("pictures"))
    $('[data-id=weather-widget]').click(=> @checkWidget("weather"))
    $('[data-id=stock-widget]').click( =>  @checkWidget("stock"))
    $('[data-id=twitter-widget]').click( => @checkWidget("twitter"))
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

  @wrapWidget: (widget, name, apiKey) ->
    new Dashboard.WidgetWrapper({widget: widget, name: name, apiKey: apiKey})

  @checkWidget: (name) ->
    wrapper = @wrappedWidgets[name]
    if !wrapper.isActive
      @setupWidget(wrapper)


  @setupWidget: (wrappedWidget)->
    container = Dashboard.Display.generateAvailableSlotFor(2, wrappedWidget.name)
    wrappedWidget.container = container
    wrappedWidget.isActive = true
    wrappedWidget.setupWidget()

  @toggleSidenav: ->
    if Dashboard.Display.isSidenavDisplayed()
      Dashboard.Display.removeSidenav()
    else
      buttons = @getSidenavButtons()
      Dashboard.Display.showSidenav(buttons)
    @rebind()

  @getSidenavButtons: ->
    widgets = _.values(@generateWrappedWidgets())
    _.map(widgets, (wrapper) ->
      wrapper.widgetLogo()
    )

  @generateWrappedWidgets: ->
    @wrappedWidgets = {
      pictures: @wrapWidget(Pictures, "pictures", "a48194703ae0d0d1055d6ded6c4c9869"),
      weather: @wrapWidget(Weather, "weather", "12ba191e2fec98ad"),
      twitter: @wrapWidget(Twitter, "twitter", ""),
      stock: @wrapWidget(Stock, "stock", "")
    }
