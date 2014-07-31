namespace("Dashboard.Widgets")

class Dashboard.Widgets.Manager
  @generateWrappers: (settings) ->
    @wrappers = {
      pictures: @wrapWidget(Pictures, "pictures", 3, "a48194703ae0d0d1055d6ded6c4c9869"),
      weather: @wrapWidget(Weather, "weather", 1, "12ba191e2fec98ad"),
      twitter: @wrapWidget(Twitter, "twitter", 2, ""),
      stock: @wrapWidget(Stock, "stock", 2, "")
    }
    if settings && settings.defaults
      @addDefaultsToWrappers()

  @wrapWidget: (widget, name, slotSize, apiKey, defaultValue) ->
    new Dashboard.Widgets.Wrapper({widget: widget, name: name, slotSize: slotSize, apiKey: apiKey})

  @addDefaultsToWrappers: ->
    @wrappers.pictures.defaultValue = 'bikes'
    @wrappers.twitter.defaultValue = 'bikes'
    @wrappers.weather.defaultValue = 'Chicago IL'
    @wrappers.stock.defaultValue = 'AAPL YHOO'

  @enterEditMode: ->
    @mapOnAllWidgets('showWidgetForm')

  @exitEditMode: ->
    @mapOnAllWidgets('hideWidgetForm')

  @getSidenavButtons: ->
    @mapOnAllWidgets('widgetLogo')

  @mapOnAllWidgets: (functionName) ->
    widgets = @getListOfWidgets()
    _.map(widgets, (wrapper) ->
      wrapper[functionName]()
    )

  @getListOfWidgets: ->
    _.values(@wrappers)

  @setupWidget: (name) ->
    wrapper = @wrappers[name]
    container = Dashboard.Widgets.Display.generateContainer(wrapper.slotSize)
    if container
      wrapper.setupWidgetIn(container)
