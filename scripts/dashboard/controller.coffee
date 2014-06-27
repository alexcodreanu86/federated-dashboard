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

  @checkWidget: (name) ->
    wrapper = @wrappedWidgets[name]
    if !wrapper.isActive
      @setupWidget(wrapper)

  @setupWidget: (wrappedWidget)->
    containerInfo = Dashboard.Display.generateAvailableSlotFor(wrappedWidget)
    if containerInfo
      wrappedWidget.setupWidgetIn(containerInfo)

  @toggleSidenav: ->
    if Dashboard.Display.isSidenavDisplayed()
      @removeSidenav()
    else
      @showSidenav()
    @rebind()

  @removeSidenav: ->
    Dashboard.Display.removeSidenav()

  @showSidenav: ->
    buttons = @getSidenavButtons()
    Dashboard.Display.showSidenav(buttons)

  @getSidenavButtons: ->
    widgets = _.values(@generateWrappedWidgets())
    _.map(widgets, (wrapper) ->
      wrapper.widgetLogo()
    )

  @generateWrappedWidgets: ->
    @wrappedWidgets = {
      pictures: @wrapWidget(Pictures, "pictures", 3, "a48194703ae0d0d1055d6ded6c4c9869"),
      weather: @wrapWidget(Weather, "weather", 1, "12ba191e2fec98ad"),
      twitter: @wrapWidget(Twitter, "twitter", 2, ""),
      stock: @wrapWidget(Stock, "stock", 2, "")
    }

  @wrapWidget: (widget, name, numberOfSlots, apiKey) ->
    new Dashboard.WidgetWrapper({widget: widget, name: name, numberOfSlots: numberOfSlots, apiKey: apiKey})

  @closeWidget: (wrapperName) ->
    wrappedWidget = @wrappedWidgets[wrapperName]
    Dashboard.Display.emptySlotsInColumn(wrappedWidget.numberOfSlots, wrappedWidget.containerColumn)
    wrappedWidget.closeWidget()
