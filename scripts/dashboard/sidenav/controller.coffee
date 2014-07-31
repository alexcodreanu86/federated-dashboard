namespace('Dashboard.Sidenav')

class Dashboard.Sidenav.Controller
  @bindSetupWidgets: ->
    $('[data-id=widgets-menu] li img').click( ->
      Dashboard.Sidenav.Controller.processClickedButton(this)
    )

  @processClickedButton: (button) ->
    buttonDataId = button.getAttribute('data-id')
    widgetName = @getWidgetName(buttonDataId)
    Dashboard.Widgets.Manager.setupWidget(widgetName)

  @getWidgetName: (dataId) ->
    dataId.split('-')[0]
