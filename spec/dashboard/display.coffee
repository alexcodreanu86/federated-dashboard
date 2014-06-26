setupDashboardFixtures = ->
  setFixtures """
            <button data-id="pictures-widget">Pictures</button>
            <button data-id="weather-widget">Weather</button>
            <button data-id="stock-widget">Stock</button>
            <div data-id="widget-display"></div>
            """
assertFormElementAreInDOM = ->
  expect($('[name=my-widget-search]')).toBeInDOM()
  expect($('[data-id=my-widget-button]')).toBeInDOM()

buttons = Dashboard.Controller.getSidenavButtons()

displaySidenav = ->
  setFixtures "<div data-id='side-nav'></div>"
  Dashboard.Display.showSidenav(buttons)

clickOn = (element) ->
  $(element).click()

describe 'Dashboard.Display', ->

  it "populateWidget adds html to the widget display container", ->
    setFixtures "<div data-id='widget-display'></div>"
    Dashboard.Display.populateWidget('<h1>Hello world</h1>')
    expect($('[data-id=widget-display]').html()).toEqual('<h1>Hello world</h1>')

  it "generateForm returns html for the desired widget", ->
    setupDashboardFixtures()
    html = Dashboard.Display.generateForm('my-widget')
    $('[data-id=widget-display]').append(html)
    assertFormElementAreInDOM()

  it "showSidenav displays the sideNav", ->
    displaySidenav()
    expect($('[data-id=side-nav]')).toContainElement('[data-id=pictures-widget]')
    expect($('[data-id=side-nav]')).toContainElement('[data-id=weather-widget]')
    expect($('[data-id=side-nav]')).toContainElement('[data-id=stock-widget]')
    expect($('[data-id=side-nav]')).toContainElement('[data-id=twitter-widget]')

  it "removeSidenav removes the sidenav of the screen", ->
    displaySidenav()
    expect($('[data-id=side-nav]')).toContainElement('[data-id=pictures-widget]')
    Dashboard.Display.removeSidenav()
    expect($('[data-id=side-nav]')).toBeEmpty()

  it "isSidenavDisplayed returns true when it is displayed", ->
    displaySidenav()
    expect(Dashboard.Display.isSidenavDisplayed()).toBe(true)

  it "isSidenavDisplayed returns false when it is displayed", ->
    setFixtures "<div data-id='side-nav'></div>"
    expect(Dashboard.Display.isSidenavDisplayed()).toBe(false)

