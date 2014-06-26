clickOn = (element) ->
  $(element).click()

setupDashboardFixtures = ->
  setFixtures """
            <button data-id="pictures-widget">Pictures</button>
            <button data-id="weather-widget">Weather</button>
            <button data-id="stock-widget">Stock</button>
            <div data-id="widget-display"></div>
            """

assertSidenavGetsLoaded = ->
  setFixtures "<image data-id='menu-button'/><div data-id='side-nav'></div>"
  Dashboard.Controller.bind()
  clickOn('[data-id=menu-button]')
  expect($('[data-id=side-nav]')).not.toBeEmpty()


describe "Dashboard.Controller", ->
  beforeEach ->
    setupDashboardFixtures()
    Dashboard.Controller.bind()

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

  it "loadForm binds the widget Controller to listen for clicks", ->
    spy = spyOn(Weather.Controller, 'bind')
    Dashboard.Controller.loadForm('weather', Weather.Controller)
    expect(spy).toHaveBeenCalled()

  it "toggleSidenav displays the side-nav when the menu button is clicked", ->
    assertSidenavGetsLoaded()

  it "toggleSidenav removes the side-nav when menu-button is clicked and side-nav is on the screen", ->
    assertSidenavGetsLoaded()
    clickOn('[data-id=menu-button]')
    expect($('[data-id=side-nav]')).toBeEmpty()

  it "getSidenavButtons returns an object containing the buttons for the desired widgets", ->
    buttons = Dashboard.Controller.getSidenavButtons()
    expect(buttons[0]).toBeMatchedBy("[data-id=twitter-widget]")
    expect(buttons[1]).toBeMatchedBy("[data-id=pictures-widget]")
