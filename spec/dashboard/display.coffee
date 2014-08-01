wrappedWidget = new Dashboard.Widgets.Wrapper({widget: Pictures, name: "pictures", numberOfSlots: 3, apiKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"})

Dashboard.Widgets.Manager.generateWrappers()
buttons = Dashboard.Widgets.Manager.getSidenavButtons()

displaySidenav = ->
  setSidenavContainer()
  Dashboard.Display.showSidenav(buttons)

setSidenavContainer = ->
  setFixtures "<div data-id='widget-buttons'></div>"

buttonsContainer = '[data-id=widget-buttons]'

clickOn = (element) ->
  $(element).click()

describe 'Dashboard.Display', ->
  it "showSidenav displays the sideNav", ->
    displaySidenav()
    expect($(buttonsContainer)).toContainElement('[data-id=pictures-widget]')
    expect($(buttonsContainer)).toContainElement('[data-id=weather-widget]')
    expect($(buttonsContainer)).toContainElement('[data-id=stock-widget]')
    expect($(buttonsContainer)).toContainElement('[data-id=twitter-widget]')

  it "removeSidenav removes the sidenav of the screen", ->
    displaySidenav()
    Dashboard.Display.removeSidenav()
    expect($(buttonsContainer)).toBeEmpty()

  it "isSidenavDisplayed returns false if sidenav is not displayed", ->
    setSidenavContainer()
    expect(Dashboard.Display.isSidenavDisplayed()).toBe(false)

  it "isSidenavDisplayed returns true if sidenav is displayed", ->
    displaySidenav()
    expect(Dashboard.Display.isSidenavDisplayed()).toBe(true)
