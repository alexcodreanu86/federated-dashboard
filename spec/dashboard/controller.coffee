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
    wrapper = Dashboard.Controller.wrapWidget(Pictures, "pictures", "some-api-key")
    expect(wrapper.name).toEqual("pictures")
    expect(wrapper.widgetApiKey).toEqual("some-api-key")
    expect(wrapper.widget).toEqual(Pictures)

  it "wrappedWidgets has 4 widgets setup", ->
    Dashboard.Controller.initialize()
    widgets = _.keys(Dashboard.Controller.wrappedWidgets)
    expect(widgets.length).toEqual(4)
