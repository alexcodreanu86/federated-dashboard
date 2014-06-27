namespace('Dashboard')

INDEX_OF_CONTAINER_NAME = 0
INDEX_OF_CONTAINER_COLUMN = 1
WIDGET_LOGO_WIDTH = "50"

class Dashboard.WidgetWrapper
  isActive: false

  constructor: (config) ->
    @widget = config.widget
    @widgetApiKey = config.apiKey
    @name = config.name
    @numberOfSlots = config.numberOfSlots

  setupWidgetIn:(containerInfo) ->
    @containerName = containerInfo[INDEX_OF_CONTAINER_NAME]
    @containerColumn = containerInfo[INDEX_OF_CONTAINER_COLUMN]
    @isActive = true
    @widget.Controller.setupWidgetIn(@containerName, @widgetApiKey)

  widgetLogo: ->
    dataId = "#{@name}-widget"
    @widget.Display.generateLogo({dataId: dataId, width: WIDGET_LOGO_WIDTH})

  closeWidget: ->
    $(@containerName).remove()
    @isActive = false
