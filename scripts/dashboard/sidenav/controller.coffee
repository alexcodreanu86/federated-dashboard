namespace('Dashboard.Sidenav')

class Dashboard.Sidenav.Controller
  constructor: (@widgetManager) ->
  bindSetupWidgets: () ->
    $('[data-id=widget-buttons] li i').click (event) =>
      @processClickedButton event

  processClickedButton: (event) ->
    button = $(event.target)
    buttonDataId = button.attr('data-id')
    widgetName = @getWidgetName(buttonDataId)
    @widgetManager.setupWidget(widgetName)

  getWidgetName: (dataId) ->
    dataId.split('-')[0]
