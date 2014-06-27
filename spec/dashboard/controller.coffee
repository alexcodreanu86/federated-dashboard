clickOn = (element) ->
  $(element).click()

setupDashboardFixtures = ->
  setFixtures """
            <button data-id="pictures-widget">Pictures</button>
            <button data-id="weather-widget">Weather</button>
            <button data-id="stock-widget">Stock</button>
            <div data-id="widget-display">
              <div data-id="col0"></div>
              <div data-id="col1"></div>
              <div data-id="col2"></div>
            </div>
            """

assertSidenavGetsLoaded = ->
  setFixtures "<image data-id='menu-button'/><div data-id='side-nav'></div>"
  Dashboard.Controller.bind()
  clickOn('[data-id=menu-button]')
  expect($('[data-id=side-nav]')).toContainElement('[data-id=pictures-widget]')
  expect($('[data-id=side-nav]')).toContainElement('[data-id=weather-widget]')
  expect($('[data-id=side-nav]')).toContainElement('[data-id=stock-widget]')
  expect($('[data-id=side-nav]')).toContainElement('[data-id=twitter-widget]')

getWidget = (name) ->
  Dashboard.Controller.wrappedWidgets[name]

setWidgetStatus = (name, status) ->
  getWidget(name).isActive = status

resetController = ->
  Dashboard.Controller.initialize()
  resetSlots()

resetSlots = ->
  Dashboard.Display.takenSlots.col0 = 0
  Dashboard.Display.takenSlots.col1 = 0
  Dashboard.Display.takenSlots.col2 = 0

describe "Dashboard.Controller", ->
  beforeEach ->
    setupDashboardFixtures()
    Dashboard.Controller.initialize()

  afterEach ->
    $(document).unbind('click')

  it "bind displays the form for pictures when the pictures button is clicked", ->
    clickOn('[data-id=pictures-widget]')
    expect($('[data-id=pictures-button]')).toBeInDOM()

  it "bind displays the form for weather when the weather button is clicked", ->
    clickOn('[data-id=weather-widget]')
    expect($('[data-id=weather-button]')).toBeInDOM()

  it "bind displays the form for stocks when the stock button is clicked", ->
    clickOn('[data-id=stock-widget]')
    expect($('[data-id=stock-button]')).toBeInDOM()

  it "unbind unbinds all click bindings", ->
    Dashboard.Controller.unbind()
    clickOn('[data-id=pictures-widget]')
    expect($('[data-id=pictures-button]')).not.toBeInDOM()

  it "toggleSidenav displays the side-nav when the menu button is clicked", ->
    assertSidenavGetsLoaded()

  it "toggleSidenav removes the side-nav when menu-button is clicked and side-nav is on the screen", ->
    assertSidenavGetsLoaded()
    clickOn('[data-id=menu-button]')
    expect($('[data-id=side-nav]')).toBeEmpty()

  it "wrapWidget returns a new widgetWrapper", ->
    wrapper = Dashboard.Controller.wrapWidget(Pictures, "pictures", 3, "some-api-key")
    expect(wrapper.name).toEqual("pictures")
    expect(wrapper.widgetApiKey).toEqual("some-api-key")
    expect(wrapper.numberOfSlots).toEqual(3)
    expect(wrapper.widget).toEqual(Pictures)

  it "wrappedWidgets has 4 widgets setup", ->
    resetController()
    widgets = _.keys(Dashboard.Controller.wrappedWidgets)
    expect(widgets.length).toEqual(4)

  it "checkWidget sets up the widget if it is not active", ->
    resetController()
    spy = spyOn(Dashboard.Controller, 'setupWidget')
    Dashboard.Controller.checkWidget("pictures")
    expect(spy).toHaveBeenCalled()

  it "checkWidget does not set up the widget if it is active already", ->
    resetController()
    spy = spyOn(Dashboard.Controller, 'setupWidget')
    setWidgetStatus("pictures", true)
    Dashboard.Controller.checkWidget("pictures")
    expect(spy).not.toHaveBeenCalled()

  it "setupWidget is setting the widget if a container is available for it", ->
    resetController()
    picturesWidget = getWidget("pictures")
    Dashboard.Controller.setupWidget(picturesWidget)
    expect(picturesWidget.isActive).toBe(true)

  it "setupWidget doesn't set the widget if a container is not available for it", ->
    resetController()
    spyOn(Dashboard.Display, "generateAvailableSlotFor").and.returnValue(undefined)
    picturesWidget = getWidget("pictures")
    Dashboard.Controller.setupWidget(picturesWidget)
    expect(picturesWidget.isActive).toBe(false)

  it "closeWidget is closing the widget that is given to it", ->
    resetController()
    setFixtures(sandbox())
    picturesWrapped = Dashboard.Controller.wrappedWidgets.pictures
    picturesWrapped.setupWidgetIn("#sandbox")
    expect(picturesWrapped.isActive).toBe(true)
    Dashboard.Controller.closeWidget("pictures")
    expect(picturesWrapped.isActive).toBe(false)

  it "closeWidget updates the view slots", ->
    setupDashboardFixtures()
    resetController()
    clickOn("[data-id=pictures-widget]")
    expect(Dashboard.Display.takenSlots.col0).toEqual(3)
    Dashboard.Controller.closeWidget("pictures")
    expect(Dashboard.Display.takenSlots.col0).toEqual(0)
    resetSlots()
