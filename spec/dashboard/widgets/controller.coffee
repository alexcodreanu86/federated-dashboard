clickOn = (element) -> $(element).click()

setupDashboardFixtures = ->
  setFixtures """
    <img data-id="menu-button">
    <div data-id="side-nav"></div>
    <div data-id="widget-display">
      <div class="widget-col"><ul class='widget-list' data-id="col0"></ul></div>
      <div class="widget-col"><ul class='widget-list' data-id="col1"></ul></div>
      <div class="widget-col"><ul class='widget-list' data-id="col2"></ul></div>
    </div>
  """

getWidget = (name) ->
  Dashboard.Widgets.Manager.wrappers[name]

resetController = ->
  Dashboard.Controller.initialize()
  resetSlots()

setWidgetStatus = (name, status) ->
  getWidget(name).isActive = status


setupAndBindController = ->
  resetSlots()
  Dashboard.Widgets.Manager.generateWrappers()
  setupDashboardFixtures()
  Dashboard.Controller.setupSidenav()
  Dashboard.Sidenav.Controller.rebindButtons()

resetSlots = ->
  Dashboard.Columns.Controller.takenSlots.col0 = 0
  Dashboard.Columns.Controller.takenSlots.col1 = 0
  Dashboard.Columns.Controller.takenSlots.col2 = 0

describe "Dashboard.Widgets.Controller", ->
  it "checkWidget sets up the widget if it is not active", ->
    setupAndBindController()
    spy = spyOn(Dashboard.Widgets.Controller, 'setupWidget')
    Dashboard.Widgets.Controller.checkWidget("pictures")
    expect(spy).toHaveBeenCalled()

  it "setupWidget is setting the widget if a container is available for it", ->
    setupAndBindController()
    picturesWidget = getWidget("pictures")
    Dashboard.Widgets.Controller.setupWidget(picturesWidget)
    expect(picturesWidget.isActive).toBe(true)

  it "setupWidget is setting the closing button", ->
    setupAndBindController()
    weatherWidget = getWidget("weather")
    Dashboard.Widgets.Controller.setupWidget(weatherWidget)
    expect($(weatherWidget.containerName)).toContainElement('.widget-close')

  it "setupWidget doesn't set the widget if a container is not available for it", ->
    setupAndBindController()
    spyOn(Dashboard.Columns.Controller, "generateAvailableSlotFor").and.returnValue(undefined)
    picturesWidget = getWidget("pictures")
    Dashboard.Widgets.Controller.setupWidget(picturesWidget)
    expect(picturesWidget.isActive).toBe(false)

  it "setupWidget resets the widgets draggable feature between columns", ->
    setupAndBindController()
    spy = spyOn(Dashboard.Columns.Controller, 'enableDraggableWidgets')
    picturesWidget = getWidget("pictures")
    Dashboard.Widgets.Controller.setupWidget(picturesWidget)
    expect(spy).toHaveBeenCalled()

  it "enterEditMode adds closing buttons to the widgets containers", ->
    setupAndBindController()
    clickOn('[data-id=weather-widget]')
    Dashboard.Controller.removeSidenav()
    weatherWrapper = Dashboard.Widgets.Manager.wrappers.weather
    expect($('.widget-close').attr('style')).toEqual('display: none;')
    Dashboard.Widgets.Controller.enterEditMode()
    expect($(weatherWrapper.containerName)).toContainElement('.widget-close')

  it "enterEditMode shows the forms for the widgets", ->
    spy = spyOn(Dashboard.Widgets.Manager, 'showActiveForms')
    Dashboard.Widgets.Controller.initialize()
    Dashboard.Widgets.Controller.enterEditMode()
    expect(spy).toHaveBeenCalled()

  it "exitEditMode removes closing buttons from the widgets containers", ->
    setupAndBindController()
    clickOn('[data-id=weather-widget]')
    weatherWrapper = Dashboard.Widgets.Manager.wrappers.weather
    expect($('.widget-close').attr('style')).not.toEqual('display: none;')
    Dashboard.Widgets.Controller.exitEditMode()
    expect($('.widget-close').attr('style')).toEqual('display: none;')

  it "exitEditMode hides the forms for the widgets", ->
    spy = spyOn(Dashboard.Widgets.Manager, 'hideActiveForms')
    Dashboard.Widgets.Controller.initialize()
    Dashboard.Widgets.Controller.exitEditMode()
    expect(spy).toHaveBeenCalled()

  it "exitEditMode removes the widget-handle from the widgets containers", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    expect($(picturesWrapper.containerName)).toContainElement('[data-name=pictures].widget-handle')
    Dashboard.Widgets.Controller.exitEditMode()
    expect($(picturesWrapper.containerName)).not.toContainElement('[data-name=pictures].widget-handle')
