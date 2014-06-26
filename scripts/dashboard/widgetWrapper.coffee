namespace('Dashboard')

class Dashboard.WidgetWrapper
  constructor: (config) ->
    @widget = config.widget
    @widgetApiKey = config.apiKey
    @name = config.name

  setupWidget: ->
    @widget.Controller.setupWidgetIn(@container, @widgetApiKey)

  isActive: false

  widgetLogo: ->
    dataId = "#{@name}-widget"
    @widget.Display.generateLogo({dataId: dataId, width: "50"})
