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

  it "checkWidget does not set up the widget if it is active already", ->
    spy = spyOn(Dashboard.Widgets.Controller, 'setupWidget')
    setWidgetStatus("pictures", true)
    Dashboard.Widgets.Controller.checkWidget("pictures")
    expect(spy).not.toHaveBeenCalled()

  it "setupWidget is setting the widget if a container is available for it", ->
    setupAndBindController()
    picturesWidget = getWidget("pictures")
    Dashboard.Widgets.Controller.setupWidget(picturesWidget)
    expect(picturesWidget.isActive).toBe(true)

  it "setupWidget is setting the button as active if the widget is setup succesfully", ->
    setupAndBindController()
    picturesWidget = getWidget("pictures")
    Dashboard.Widgets.Controller.setupWidget(picturesWidget)
    expect($('[data-id=side-nav] li').first()).toBeMatchedBy('.active')

  it "setupWidget is setting the closing button", ->
    setupAndBindController()
    picturesWidget = getWidget("pictures")
    Dashboard.Widgets.Controller.setupWidget(picturesWidget)
    expect($(picturesWidget.containerName)).toContainElement('.close-widget')

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

  it "closeWidget is closing the widget that is given to it", ->
    resetController()
    setFixtures(sandbox())
    picturesWrapped = getWidget('pictures')
    picturesWrapped.setupWidgetIn("#sandbox")
    expect(picturesWrapped.isActive).toBe(true)
    Dashboard.Widgets.Controller.closeWidget("pictures")
    expect(picturesWrapped.isActive).toBe(false)

  it "closeWidget updates the view slots", ->
    setupAndBindController()
    clickOn("[data-id=pictures-widget]")
    expect(Dashboard.Columns.Controller.takenSlots.col0).toEqual(3)
    Dashboard.Widgets.Controller.closeWidget("pictures")
    expect(Dashboard.Columns.Controller.takenSlots.col0).toEqual(0)
    resetSlots()

  it "closeWidget is resetting the button as inactive", ->
    setupAndBindController()
    picturesWidget = getWidget("pictures")
    Dashboard.Widgets.Controller.setupWidget(picturesWidget)
    expect($('[data-id=side-nav] li').first()).toBeMatchedBy('.active')
    Dashboard.Widgets.Controller.closeWidget('pictures')
    expect($('[data-id=side-nav] li').first()).not.toBeMatchedBy('.active')

  it "bindClosingWidgets closes the pictures widget when the pictures close button is clicked", ->
    setupAndBindController()
    Dashboard.Widgets.Controller.bindClosingWidgets()
    clickOn('[data-id=pictures-widget]')
    expect('[data-name=pictures].close-widget').toBeInDOM()
    clickOn('[data-name=pictures].close-widget')
    expect($('[data-id=pictures-slot]')).not.toBeInDOM()

  it "enterEditMode adds closing buttons to the widgets containers", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    Dashboard.Controller.removeSidenav()
    picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    expect($(picturesWrapper.containerName)).not.toContainElement('[data-name=pictures].close-widget')
    Dashboard.Widgets.Controller.enterEditMode()
    expect($(picturesWrapper.containerName)).toContainElement('[data-name=pictures].close-widget')

  it "enterEditMode shows the forms for the widgets", ->
    spy = spyOn(Dashboard.Widgets.Manager, 'showActiveForms')
    Dashboard.Widgets.Controller.initialize()
    Dashboard.Widgets.Controller.enterEditMode()
    expect(spy).toHaveBeenCalled()

  it "exitEditMode removes closing buttons from the widgets containers", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    expect($(picturesWrapper.containerName)).toContainElement('[data-name=pictures].close-widget')
    Dashboard.Widgets.Controller.exitEditMode()
    expect($(picturesWrapper.containerName)).not.toContainElement('[data-name=pictures].close-widget')

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
