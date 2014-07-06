namespace('Dashboard.Widgets')

class Dashboard.Widgets.Wrapper
  WIDGET_LOGO_WIDTH = "50"

  isActive: false

  constructor: (config) ->
    @widget = config.widget
    @widgetApiKey = config.apiKey
    @name = config.name
    @numberOfSlots = config.numberOfSlots

  setupWidgetIn:(containerInfo) ->
    @containerName = containerInfo.containerName
    @containerColumn = containerInfo.containerColumn
    @isActive = true
    @widget.Controller.setupWidgetIn(@containerName, @widgetApiKey)

  widgetLogo: ->
    dataId = "#{@name}-widget"
    button = @widget.Display.generateLogo({dataId: dataId, width: WIDGET_LOGO_WIDTH})
    {html: button, isActive: @isActive}

  deactivateWidget: ->
    $(@containerName).remove()
    @isActive = false

  addClosingButtonToContainer: ->
    dataId = "#{@name}-closing-button"
    $(@containerName).prepend("<button data-id='#{dataId}'>X</button>")
