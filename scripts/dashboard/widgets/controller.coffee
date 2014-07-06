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
    containerInfo = Dashboard.Widgets.Display.generateAvailableSlotFor(wrappedWidget)
    if containerInfo
      Dashboard.Sidenav.Display.setButtonActive(wrappedWidget)
      wrappedWidget.setupWidgetIn(containerInfo)
      containerInfo = Dashboard.Widgets.Manager.getContainerAndNameOf(wrappedWidget)
      Dashboard.Widgets.Display.addButtonToContainer(containerInfo)

  @enterEditMode: ->
    activeWidgetsInfo = Dashboard.Widgets.Manager.getActiveWidgetsData()
    Dashboard.Widgets.Display.addClosingButtonsFor(activeWidgetsInfo)

  @bindClosingWidgets: ->
    $(document).on('click', '.close-widget', (event) => @getWidgetToBeClosed(event))

  @getWidgetToBeClosed: (event) ->
    wrapperName = $(event.currentTarget).attr('data-name')
    @closeWidget(wrapperName)

  @closeWidget: (wrapperName) ->
    wrappedWidget = Dashboard.Widgets.Manager.wrappers[wrapperName]
    Dashboard.Widgets.Display.emptySlotsInColumn(wrappedWidget.numberOfSlots, wrappedWidget.containerColumn)
    Dashboard.Sidenav.Display.setButtonInactive(wrappedWidget)
    wrappedWidget.deactivateWidget()
