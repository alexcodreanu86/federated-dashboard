namespace('Dashboard.Widgets')

class Dashboard.Widgets.Controller
  @initialize: ->
    Dashboard.Widgets.Manager.generateWrappers()
    @bindClosingWidgets()

  @checkWidget: (name) ->
    wrapper = Dashboard.Widgets.Manager.wrappers[name]
    if !wrapper.isActive
      @setupWidget(wrapper)

  @setupWidget: (wrappedWidget)->
    containerInfo = Dashboard.Columns.Controller.generateAvailableSlotFor(wrappedWidget)
    if containerInfo
      Dashboard.Sidenav.Display.setButtonActive(wrappedWidget)
      wrappedWidget.setupWidgetIn(containerInfo)
      containerInfo = Dashboard.Widgets.Manager.getContainerAndNameOf(wrappedWidget)
      Dashboard.Widgets.Display.addButtonAndHandleToContainer(containerInfo)
      Dashboard.Columns.Controller.enableDraggableWidgets()


  @enterEditMode: ->
    activeWidgetsInfo = Dashboard.Widgets.Manager.getActiveWidgetsData()
    Dashboard.Widgets.Display.addEditingButtonsFor(activeWidgetsInfo)
    Dashboard.Widgets.Manager.showActiveForms()

  @exitEditMode: ->
    Dashboard.Widgets.Display.removeEditButtons()
    Dashboard.Widgets.Manager.hideActiveForms()

  @bindClosingWidgets: ->
    $(document).on('click', '.close-widget', (event) =>
      wrapperName = @getWidgetToBeClosed(event)
      @closeWidget(wrapperName)
    )

  @getWidgetToBeClosed: (event) ->
    wrapperName = $(event.currentTarget).attr('data-name')

  @closeWidget: (wrapperName) ->
    wrappedWidget = Dashboard.Widgets.Manager.wrappers[wrapperName]
    Dashboard.Columns.Controller.emptySlotsInColumn(wrappedWidget.slotSize, wrappedWidget.containerColumn)
    Dashboard.Sidenav.Display.setButtonInactive(wrappedWidget)
    wrappedWidget.deactivateWidget()
