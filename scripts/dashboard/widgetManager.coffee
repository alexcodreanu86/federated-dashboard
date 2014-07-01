namespace("Dashboard")

class Dashboard.WidgetManager
  @wrapWidget: (widget, name, numberOfSlots, apiKey) ->
    new Dashboard.WidgetWrapper({widget: widget, name: name, numberOfSlots: numberOfSlots, apiKey: apiKey})

  @generateWrappers: ->
    @wrappers = {
      pictures: @wrapWidget(Pictures, "pictures", 3, "a48194703ae0d0d1055d6ded6c4c9869"),
      weather: @wrapWidget(Weather, "weather", 1, "12ba191e2fec98ad"),
      twitter: @wrapWidget(Twitter, "twitter", 2, ""),
      stock: @wrapWidget(Stock, "stock", 2, "")
    }

  @getActiveWidgets: ->
    _.filter(Dashboard.WidgetManager.wrappers, (widget) ->
      widget.isActive
    )

  @getSidenavButtons: ->
    widgets = _.values(Dashboard.WidgetManager.wrappers)
    _.map(widgets, (wrapper) ->
      wrapper.widgetLogo()
    )

  @getActiveWidgetsData: ->
    activeWidgets = @getActiveWidgets()
    _.map(activeWidgets, @getContainerAndNameOf)

  @getContainerAndNameOf: (wrapper) ->
    {
      container: wrapper.containerName,
      name: wrapper.name
    }
