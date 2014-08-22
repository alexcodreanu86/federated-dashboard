namespace('Dashboard.Widgets')

class Dashboard.Widgets.Wrapper
  WIDGET_LOGO_WIDTH = "50"

  constructor: (config) ->
    @widget       = config.widget
    @name         = config.name
    @slotSize     = @getSlotSize(config.slotSize)
    @config       = config

  getSlotSize: (sizeLetter) ->
    switch sizeLetter
      when "S", "s" then 1
      when "M", "m" then 2
      else 3

  setupWidgetIn:(container) ->
    widgetConfig = _.extend(@config, {container: container, defaultValue: @defaultValue})
    @widget.Controller.setupWidgetIn(widgetConfig)

  widgetLogo: ->
    settings = {dataId: "#{@name}-widget", class: 'icon'}
    @widget.Display.generateLogo(settings)

  hideWidgetForm: ->
    @widget.Controller.exitEditMode()

  showWidgetForm: ->
    @widget.Controller.enterEditMode()
