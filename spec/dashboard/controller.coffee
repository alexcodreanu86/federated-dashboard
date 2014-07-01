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
  Dashboard.WidgetManager.wrappers[name]

setWidgetStatus = (name, status) ->
  getWidget(name).isActive = status

resetController = ->
  Dashboard.Controller.initialize()
  resetSlots()

setupAndBindController = ->
  resetSlots()
  Dashboard.WidgetManager.generateWrappers()
  setupDashboardFixtures()
  Dashboard.Controller.showSidenav()
  Dashboard.Controller.bindSidenavButtons()

assertSidenavGetsLoaded = ->
  setFixtures "<image data-id='menu-button'/><div data-id='side-nav'></div>"
  resetController()
  clickOn('[data-id=menu-button]')
  expect($('[data-id=side-nav]')).toContainElement('[data-id=pictures-widget]')
  expect($('[data-id=side-nav]')).toContainElement('[data-id=weather-widget]')
  expect($('[data-id=side-nav]')).toContainElement('[data-id=stock-widget]')
  expect($('[data-id=side-nav]')).toContainElement('[data-id=twitter-widget]')

resetSlots = ->
  Dashboard.Display.takenSlots.col0 = 0
  Dashboard.Display.takenSlots.col1 = 0
  Dashboard.Display.takenSlots.col2 = 0

describe "Dashboard.Controller", ->
  afterEach ->
    $(document).unbind('click')

  it "bindSidenavButtons displays the form for pictures when the pictures button is clicked", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    expect($('[data-id=pictures-button]')).toBeInDOM()

  it "bindSidenavButtons displays the form for weather when the weather button is clicked", ->
    setupAndBindController()
    clickOn('[data-id=weather-widget]')
    expect($('[data-id=weather-button]')).toBeInDOM()

  it "bindSidenavButtons displays the form for stocks when the stock button is clicked", ->
    setupAndBindController()
    clickOn('[data-id=stock-widget]')
    expect($('[data-id=stock-button]')).toBeInDOM()

  it "bindClosingWidgets closes the pictures widget when the pictures close button is clicked", ->
    setupAndBindController()
    Dashboard.Controller.bindClosingWidgets()
    clickOn('[data-id=pictures-widget]')
    expect('[data-name=pictures].close-widget').toBeInDOM()
    clickOn('[data-name=pictures].close-widget')
    expect($('[data-id=pictures-slot]')).not.toBeInDOM()

  it "unbind unbinds all click bindings", ->
    setupAndBindController()
    Dashboard.Controller.unbind()
    clickOn('[data-id=pictures-widget]')
    expect($('[data-id=pictures-button]')).not.toBeInDOM()

  it "toggleSidenav displays the side-nav when the menu button is clicked", ->
    assertSidenavGetsLoaded()

  it "toggleSidenav removes the side-nav when menu-button is clicked and side-nav is on the screen", ->
    assertSidenavGetsLoaded()
    clickOn('[data-id=menu-button]')
    expect($('[data-id=side-nav]')).toBeEmpty()

  it "wrappedWidgets has 4 widgets setup", ->
    widgets = _.keys(Dashboard.WidgetManager.wrappers)
    expect(widgets.length).toEqual(4)

  it "checkWidget sets up the widget if it is not active", ->
    spy = spyOn(Dashboard.Controller, 'setupWidget')
    Dashboard.Controller.checkWidget("pictures")
    expect(spy).toHaveBeenCalled()

  it "checkWidget does not set up the widget if it is active already", ->
    spy = spyOn(Dashboard.Controller, 'setupWidget')
    setWidgetStatus("pictures", true)
    Dashboard.Controller.checkWidget("pictures")
    expect(spy).not.toHaveBeenCalled()

  it "setupWidget is setting the widget if a container is available for it", ->
    setupAndBindController()
    picturesWidget = getWidget("pictures")
    Dashboard.Controller.setupWidget(picturesWidget)
    expect(picturesWidget.isActive).toBe(true)

  it "setupWidget is setting the button as active if the widget is setup succesfully", ->
    setupAndBindController()
    picturesWidget = getWidget("pictures")
    Dashboard.Controller.setupWidget(picturesWidget)
    expect($('[data-id=side-nav] li').first()).toBeMatchedBy('.active')

  it "setupWidget is setting the closing button", ->
    setupAndBindController()
    picturesWidget = getWidget("pictures")
    Dashboard.Controller.setupWidget(picturesWidget)
    expect($(picturesWidget.containerName)).toContainElement('.close-widget')

  it "setupWidget doesn't set the widget if a container is not available for it", ->
    setupAndBindController()
    spyOn(Dashboard.Display, "generateAvailableSlotFor").and.returnValue(undefined)
    picturesWidget = getWidget("pictures")
    Dashboard.Controller.setupWidget(picturesWidget)
    expect(picturesWidget.isActive).toBe(false)

  it "closeWidget is closing the widget that is given to it", ->
    resetController()
    setFixtures(sandbox())
    picturesWrapped = Dashboard.WidgetManager.wrappers.pictures
    picturesWrapped.setupWidgetIn("#sandbox")
    expect(picturesWrapped.isActive).toBe(true)
    Dashboard.Controller.closeWidget("pictures")
    expect(picturesWrapped.isActive).toBe(false)

  it "closeWidget updates the view slots", ->
    setupAndBindController()
    clickOn("[data-id=pictures-widget]")
    expect(Dashboard.Display.takenSlots.col0).toEqual(3)
    Dashboard.Controller.closeWidget("pictures")
    expect(Dashboard.Display.takenSlots.col0).toEqual(0)
    resetSlots()

  it "closeWidget is resetting the button as inactive", ->
    setupAndBindController()
    picturesWidget = getWidget("pictures")
    Dashboard.Controller.setupWidget(picturesWidget)
    expect($('[data-id=side-nav] li').first()).toBeMatchedBy('.active')
    Dashboard.Controller.closeWidget('pictures')
    expect($('[data-id=side-nav] li').first()).not.toBeMatchedBy('.active')

  it "showSidenav enables widget editing", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    Dashboard.Controller.removeSidenav()
    Dashboard.Controller.showSidenav()
    picturesWrapper = Dashboard.WidgetManager.wrappers.pictures
    expect($(picturesWrapper.containerName)).toContainElement('[data-name=pictures].close-widget')

  it "removeSidenav closes edit mode", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    Dashboard.Controller.removeSidenav()
    Dashboard.Controller.showSidenav()
    picturesWrapper = Dashboard.WidgetManager.wrappers.pictures
    expect($(picturesWrapper.containerName)).toContainElement('[data-name=pictures].close-widget')
    Dashboard.Controller.removeSidenav()
    expect($(picturesWrapper.containerName)).not.toContainElement('[data-name=pictures].close-widget')





