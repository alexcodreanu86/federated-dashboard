namespace('Dashboard.Widgets')

class Dashboard.Widgets.Wrapper
  WIDGET_LOGO_WIDTH = "50"

  constructor: (config) ->
    @widget       = config.widget
    @name         = config.name
    @slotSize     = config.slotSize
    @config       = config

  setupWidgetIn:(container) ->
    widgetConfig = _.extend(@config, {container: container, defaultValue: @defaultValue})
    @widget.Controller.setupWidgetIn(widgetConfig)

  widgetLogo: ->
    settings = {dataId: "#{@name}-widget", class: 'icon'}
    @widget.Display.generateLogo(settings)

  hideWidgetForm: ->
    @widget.Controller.hideForms()

  showWidgetForm: ->
    @widget.Controller.showForms()
