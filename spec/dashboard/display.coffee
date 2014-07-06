wrappedWidget = new Dashboard.Widgets.Wrapper({widget: Pictures, name: "pictures", numberOfSlots: 3, apiKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"})

Dashboard.Controller.initialize()
buttons = Dashboard.Widgets.Manager.getSidenavButtons()

displaySidenav = ->
  setFixtures "<div data-id='side-nav'></div>"
  Dashboard.Display.showSidenav(buttons)

clickOn = (element) ->
  $(element).click()

resetSlots = ->
  Dashboard.Display.takenSlots.col0 = 0
  Dashboard.Display.takenSlots.col1 = 0
  Dashboard.Display.takenSlots.col2 = 0

describe 'Dashboard.Display', ->
  it "showSidenav displays the sideNav", ->
    displaySidenav()
    expect($('[data-id=side-nav]')).toContainElement('[data-id=pictures-widget]')
    expect($('[data-id=side-nav]')).toContainElement('[data-id=weather-widget]')
    expect($('[data-id=side-nav]')).toContainElement('[data-id=stock-widget]')
    expect($('[data-id=side-nav]')).toContainElement('[data-id=twitter-widget]')

  it "showSidenav adds an active class to the container of the logo if the widget is active", ->
    buttons[0].isActive = true
    displaySidenav()
    expect($('[data-id=side-nav] li').first()).toBeMatchedBy('.active')
    buttons[0].isActive = false

  it "isSidenavDisplayed returns true when it is displayed", ->
    displaySidenav()
    expect(Dashboard.Display.isSidenavDisplayed()).toBe(true)

  it "isSidenavDisplayed returns false when it is displayed", ->
    setFixtures "<div data-id='side-nav'></div>"
    expect(Dashboard.Display.isSidenavDisplayed()).toBe(false)

  it "removeSidenav removes the sidenav of the screen", ->
    displaySidenav()
    expect($('[data-id=side-nav]')).toContainElement('[data-id=pictures-widget]')
    Dashboard.Display.removeSidenav()
    expect($('[data-id=side-nav]')).toBeEmpty()
