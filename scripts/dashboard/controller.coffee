namespace('Dashboard')

class Dashboard.Controller
  @initialize: (settings) ->
    @bindMenuButton()
    Dashboard.Widgets.Manager.generateWrappers(settings)

  @bindMenuButton: ->
    $('[data-id=menu-button]').click(=> @toggleSidenav())

  @toggleSidenav: ->
    if Dashboard.Display.isSidenavDisplayed()
      @removeSidenav()
    else
      @setupSidenav()

  @setupSidenav: ->
    Dashboard.Display.showSidenav(@getButtons())
    Dashboard.Sidenav.Controller.bindSetupWidgets()
    Dashboard.Widgets.Manager.enterEditMode()
    Dashboard.Widgets.Sorter.setupSortable()

  @getButtons: ->
    @sidenavButtons ||= Dashboard.Widgets.Manager.getSidenavButtons()

  @removeSidenav: ->
    Dashboard.Display.removeSidenav()
    Dashboard.Widgets.Manager.exitEditMode()
    Dashboard.Widgets.Sorter.disableSortable()
