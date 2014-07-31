wrappedWidget = new Dashboard.Widgets.Wrapper({widget: Pictures, name: "pictures", numberOfSlots: 3, apiKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"})

Dashboard.Widgets.Manager.generateWrappers()
buttons = Dashboard.Widgets.Manager.getSidenavButtons()

displaySidenav = ->
  setSidenavContainer()
  Dashboard.Display.showSidenav(buttons)

setSidenavContainer = ->
  setFixtures "<div data-id='side-nav'></div>"

clickOn = (element) ->
  $(element).click()

describe 'Dashboard.Display', ->
  it "showSidenav displays the sideNav", ->
    displaySidenav()
    expect($('[data-id=side-nav]')).toContainElement('[data-id=pictures-widget]')
    expect($('[data-id=side-nav]')).toContainElement('[data-id=weather-widget]')
    expect($('[data-id=side-nav]')).toContainElement('[data-id=stock-widget]')
    expect($('[data-id=side-nav]')).toContainElement('[data-id=twitter-widget]')

  it "removeSidenav removes the sidenav of the screen", ->
    displaySidenav()
    Dashboard.Display.removeSidenav()
    expect($('[data-id=side-nav]')).toBeEmpty()

  it "isSidenavDisplayed returns false if sidenav is not displayed", ->
    setSidenavContainer()
    expect(Dashboard.Display.isSidenavDisplayed()).toBe(false)

  it "isSidenavDisplayed returns true if sidenav is displayed", ->
    displaySidenav()
    expect(Dashboard.Display.isSidenavDisplayed()).toBe(true)
