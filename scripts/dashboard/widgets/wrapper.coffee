namespace('Dashboard.Widgets')

class Dashboard.Widgets.Wrapper
  WIDGET_LOGO_WIDTH = "50"

  constructor: (config) ->
    @widget       = config.widget
    @widgetApiKey = config.apiKey
    @name         = config.name
    @slotSize     = config.slotSize

  setupWidgetIn:(container) ->
    @container = container
    @widget.Controller.setupWidgetIn(@container, @widgetApiKey, @defaultValue)

  widgetLogo: ->
    dataId = "#{@name}-widget"
    @widget.Display.generateLogo({dataId: dataId, width: WIDGET_LOGO_WIDTH})

  hideWidgetForm: ->
    @widget.Controller.hideForms()

  showWidgetForm: ->
    @widget.Controller.showForms()
