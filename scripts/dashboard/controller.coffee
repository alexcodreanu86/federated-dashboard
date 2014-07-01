namespace('Dashboard')

class Dashboard.Controller
  @initialize: ->
    @bindMenuButton()
    @bindSidenavButtons()
    Dashboard.WidgetManager.generateWrappers()
    @bindClosingWidgets()

  @bindClosingWidgets: ->
    $(document).on('click', '.close-widget', (event) => @getWidgetToBeClosed(event))

  @bindSidenavButtons: ->
    $('[data-id=pictures-widget]').click(=> @checkWidget("pictures"))
    $('[data-id=weather-widget]').click(=> @checkWidget("weather"))
    $('[data-id=stock-widget]').click( =>  @checkWidget("stock"))
    $('[data-id=twitter-widget]').click( => @checkWidget("twitter"))

  @unbind: ->
    $('[data-id=pictures-widget]').unbind('click')
    $('[data-id=weather-widget]').unbind('click')
    $('[data-id=stock-widget]').unbind('click')
    $('[data-id=twitter-widget]').unbind('click')

  @bindMenuButton: ->
    $('[data-id=menu-button]').click( => @toggleSidenav())

  @rebind: ->
    @unbind()
    @bindSidenavButtons()

  @getWidgetToBeClosed: (event) ->
    wrapperName = $(event.currentTarget).attr('data-name')
    @closeWidget(wrapperName)

  @checkWidget: (name) ->
    wrapper = Dashboard.WidgetManager.wrappers[name]
    if !wrapper.isActive
      @setupWidget(wrapper)

  @setupWidget: (wrappedWidget)->
    containerInfo = Dashboard.Display.generateAvailableSlotFor(wrappedWidget)
    if containerInfo
      Dashboard.Display.setSidenavButtonActive(wrappedWidget)
      wrappedWidget.setupWidgetIn(containerInfo)
      containerInfo = Dashboard.WidgetManager.getContainerAndNameOf(wrappedWidget)
      Dashboard.Display.addButtonToContainer(containerInfo)

  @closeWidget: (wrapperName) ->
    wrappedWidget = Dashboard.WidgetManager.wrappers[wrapperName]
    Dashboard.Display.emptySlotsInColumn(wrappedWidget.numberOfSlots, wrappedWidget.containerColumn)
    Dashboard.Display.setSidenavButtonInactive(wrappedWidget)
    wrappedWidget.closeWidget()

  @toggleSidenav: ->
    if Dashboard.Display.isSidenavDisplayed()
      @removeSidenav()
    else
      @showSidenav()
    @rebind()

  @removeSidenav: ->
    Dashboard.Display.removeSidenav()
    Dashboard.Display.removeClosingButtons()

  @showSidenav: ->
    buttons = Dashboard.WidgetManager.getSidenavButtons()
    Dashboard.Display.showSidenav(buttons)
    @enterEditMode()

  @enterEditMode: ->
    activeWidgetsInfo = Dashboard.WidgetManager.getActiveWidgetsData()
    Dashboard.Display.addClosingButtonsFor(activeWidgetsInfo)
