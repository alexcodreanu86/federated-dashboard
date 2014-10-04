namespace('Dashboard')

class Dashboard.Controller
  constructor: (settings) ->
    @settings          = settings
    @formsManager      = new Dashboard.Widgets.FormsManager(@animationSpeed())
    @widgetManager     = new Dashboard.Widgets.Manager(settings)
    @sidenavController = new Dashboard.Sidenav.Controller(@widgetManager)
    @widgetSorter      = new Dashboard.Widgets.Sorter(@getSortableList(), @getSortableHandle())

  animationSpeed: ->
    @speed ?= @settings && @settings.animationSpeed

  getSortableList: ->
    @settings && @settings.sortableList

  getSortableHandle: ->
    @settings && @settings.sortableHandle

  initialize: () ->
    @bindMenuButton()
    @widgetManager.generateWrappers(@settings)
    @initializeDisplay(@settings)
    @sidenavController.bindSetupWidgets()

  initializeDisplay: ->
    @display = new Dashboard.Display(@generateDisplaySettings())
    @display.initialize()

  generateDisplaySettings: ->
    displaySettings = {buttons: @getButtons()}
    displaySettings.animationSpeed = @animationSpeed()
    displaySettings

  bindMenuButton: ->
    $('[data-id=menu-button]').click(=> @toggleSidenav())

  toggleSidenav: ->
    if @display.isSidenavDisplayed()
      @removeSidenav()
    else
      @setupSidenav()

  setupSidenav: ->
    @display.showSidenav()
    @formsManager.enterEditMode()
    @widgetSorter.setupSortable()

  getButtons: ->
    @sidenavButtons ||= @widgetManager.getSidenavButtons()

  removeSidenav: ->
    @display.hideSidenav()
    @formsManager.exitEditMode()
    @widgetSorter.disableSortable()
