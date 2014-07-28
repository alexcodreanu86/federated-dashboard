namespace("Dashboard.Widgets")

class Dashboard.Widgets.Manager
  @generateWrappers: ->
    @wrappers = {
      pictures: @wrapWidget(Pictures, "pictures", 3, "a48194703ae0d0d1055d6ded6c4c9869"),
      weather: @wrapWidget(Weather, "weather", 1, "12ba191e2fec98ad"),
      twitter: @wrapWidget(Twitter, "twitter", 2, ""),
      stock: @wrapWidget(Stock, "stock", 2, "")
    }

  @wrapWidget: (widget, name, slotSize, apiKey) ->
    new Dashboard.Widgets.Wrapper({widget: widget, name: name, slotSize: slotSize, apiKey: apiKey})

  @getSidenavButtons: ->
    widgets = _.values(Dashboard.Widgets.Manager.wrappers)
    _.map(widgets, (wrapper) ->
      wrapper.widgetLogo()
    )

  @getActiveWidgetsData: ->
    activeWidgets = @getActiveWidgets()
    _.map(activeWidgets, @getContainerAndNameOf)

  @getActiveWidgets: ->
    _.filter(Dashboard.Widgets.Manager.wrappers, (widget) ->
      widget.isActive
    )

  @getContainerAndNameOf: (wrapper) ->
    {
      container: wrapper.containerName,
      name: wrapper.name
    }

  @hideActiveForms: ->
    wrappers =  @getActiveWidgets()
    _.each(wrappers, (wrapper) ->
      wrapper.hideWidgetForm()
    )

  @showActiveForms: ->
    wrappers =  @getActiveWidgets()
    _.each(wrappers, (wrapper) ->
      wrapper.showWidgetForm()
    )

  @getWrapperInContainer: (containerName) ->
    _.findWhere(@wrappers, {containerName: containerName})
