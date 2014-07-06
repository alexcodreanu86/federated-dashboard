clickOn = (element) ->
  $(element).click()

setupDashboardFixtures = ->
  setFixtures """
    <img data-id="menu-button" src="/lib/icons/hamburger.png" style="width: 75px">
    <div data-id="side-nav"></div>
    <div data-id="widget-display">
      <div class="widget-col" data-id="col0"></div>
      <div class="widget-col" data-id="col1"></div>
      <div class="widget-col" data-id="col2"></div>
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
  Dashboard.Controller.showSidenav()
  Dashboard.Sidenav.Controller.initialize()

resetSlots = ->
  Dashboard.Widgets.Display.takenSlots.col0 = 0
  Dashboard.Widgets.Display.takenSlots.col1 = 0
  Dashboard.Widgets.Display.takenSlots.col2 = 0

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
    spyOn(Dashboard.Widgets.Display, "generateAvailableSlotFor").and.returnValue(undefined)
    picturesWidget = getWidget("pictures")
    Dashboard.Widgets.Controller.setupWidget(picturesWidget)
    expect(picturesWidget.isActive).toBe(false)

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
    expect(Dashboard.Widgets.Display.takenSlots.col0).toEqual(3)
    Dashboard.Widgets.Controller.closeWidget("pictures")
    expect(Dashboard.Widgets.Display.takenSlots.col0).toEqual(0)
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

