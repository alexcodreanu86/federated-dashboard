namespace("Dashboard.Widgets")

class Dashboard.Widgets.Manager
  @wrapWidget: (widget, name, numberOfSlots, apiKey) ->
    new Dashboard.Widgets.Wrapper({widget: widget, name: name, numberOfSlots: numberOfSlots, apiKey: apiKey})

  @generateWrappers: ->
    @wrappers = {
      pictures: @wrapWidget(Pictures, "pictures", 3, "a48194703ae0d0d1055d6ded6c4c9869"),
      weather: @wrapWidget(Weather, "weather", 1, "12ba191e2fec98ad"),
      twitter: @wrapWidget(Twitter, "twitter", 2, ""),
      stock: @wrapWidget(Stock, "stock", 2, "")
    }

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
