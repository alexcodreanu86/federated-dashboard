namespace('Dashboard')

class Dashboard.Controller
  @initialize: (settings) ->
    @bindMenuButton()
    Dashboard.Widgets.Manager.generateWrappers(settings)
    @initializeDisplay(settings)
    Dashboard.Sidenav.Controller.bindSetupWidgets()

  @initializeDisplay: (settings) ->
    displaySettings = @generateDisplaySettings(settings)
    Dashboard.Display.initialize(displaySettings)

  @generateDisplaySettings: (settings) ->
    displaySettings = {buttons: @getButtons()}
    if settings
      displaySettings.animationSpeed = settings.animationSpeed
    displaySettings

  @bindMenuButton: ->
    $('[data-id=menu-button]').click(=> @toggleSidenav())

  @toggleSidenav: ->
    if Dashboard.Display.isSidenavDisplayed()
      @removeSidenav()
    else
      @setupSidenav()

  @setupSidenav: ->
    Dashboard.Display.showSidenav()
    Dashboard.Widgets.Manager.enterEditMode()
    Dashboard.Widgets.Sorter.setupSortable()

  @getButtons: ->
    @sidenavButtons ||= Dashboard.Widgets.Manager.getSidenavButtons()

  @removeSidenav: ->
    Dashboard.Display.hideSidenav()
    Dashboard.Widgets.Manager.exitEditMode()
    Dashboard.Widgets.Sorter.disableSortable()
