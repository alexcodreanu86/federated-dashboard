namespace('Dashboard.Widgets')

class Dashboard.Widgets.Controller
  @initialize: ->
    Dashboard.Widgets.Manager.generateWrappers()

  @checkWidget: (name) ->
    wrapper = Dashboard.Widgets.Manager.wrappers[name]
    @setupWidget(wrapper)

  @setupWidget: (wrappedWidget)->
    containerInfo = Dashboard.Columns.Controller.generateAvailableSlotFor(wrappedWidget)
    if containerInfo
      wrappedWidget.setupWidgetIn(containerInfo)
      containerInfo = Dashboard.Widgets.Manager.getContainerAndNameOf(wrappedWidget)
      Dashboard.Widgets.Display.addHandleToContainer(containerInfo)
      Dashboard.Columns.Controller.enableDraggableWidgets()

  @enterEditMode: ->
    activeWidgetsInfo = Dashboard.Widgets.Manager.getActiveWidgetsData()
    Dashboard.Widgets.Display.addEditingButtonsFor(activeWidgetsInfo)
    Dashboard.Widgets.Manager.showActiveForms()

  @exitEditMode: ->
    Dashboard.Widgets.Display.removeEditButtons()
    Dashboard.Widgets.Manager.hideActiveForms()

  @getWidgetToBeClosed: (event) ->
    wrapperName = $(event.currentTarget).attr('data-name')
