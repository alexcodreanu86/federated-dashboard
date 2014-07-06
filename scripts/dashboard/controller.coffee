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
      @showSidenav()

  @showSidenav: ->
    buttons = Dashboard.Widgets.Manager.getSidenavButtons()
    Dashboard.Display.showSidenav(buttons)
    @reinitializeSidenavController()

  @reinitializeSidenavController: ->
    Dashboard.Sidenav.Controller.unbind()
    Dashboard.Sidenav.Controller.initialize()

  @removeSidenav: ->
    Dashboard.Display.removeSidenav()
    Dashboard.Widgets.Display.removeClosingButtons()
