namespace('Dashboard')

class Dashboard.Controller
  @initialize: ->
    @bindMenuButton()
    Dashboard.Sidenav.Controller.bindButtons()
    Dashboard.Widgets.Controller.initialize()

  @bindMenuButton: ->
    $('[data-id=menu-button]').click( => @toggleSidenav())

  @toggleSidenav: ->
    if Dashboard.Display.isSidenavDisplayed()
      @removeSidenav()
    else
      @setupSidenav()

  @setupSidenav: ->
    buttons = Dashboard.Widgets.Manager.getSidenavButtons()
    Dashboard.Display.showSidenav(buttons)
    Dashboard.Sidenav.Controller.rebindButtons()
    Dashboard.Widgets.Controller.enterEditMode()
    Dashboard.Columns.Controller.enterEditMode()

  @removeSidenav: ->
    Dashboard.Display.removeSidenav()
    Dashboard.Widgets.Controller.exitEditMode()
    Dashboard.Columns.Controller.exitEditMode()
