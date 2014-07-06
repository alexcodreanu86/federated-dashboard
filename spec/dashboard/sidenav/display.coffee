Dashboard.Controller.initialize()
buttons = Dashboard.Widgets.Manager.getSidenavButtons()

displaySidenav = ->
  setFixtures "<div data-id='side-nav'></div>"
  Dashboard.Display.showSidenav(buttons)

resetSlots = ->
  Dashboard.Display.takenSlots.col0 = 0
  Dashboard.Display.takenSlots.col1 = 0
  Dashboard.Display.takenSlots.col2 = 0

describe "Dashboard.Sidenav.Display", ->

  it "setButtonActive adds an active class to the container of the widget button given", ->
    displaySidenav()
    expect($('[data-id=side-nav] li').first()).not.toBeMatchedBy('.active')
    widgetWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    Dashboard.Sidenav.Display.setButtonActive(widgetWrapper)
    expect($('[data-id=side-nav] li').first()).toBeMatchedBy('.active')

  it "setButtonInactive adds an active class to the container of the widget button given", ->
    displaySidenav()
    widgetWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    Dashboard.Sidenav.Display.setButtonActive(widgetWrapper)
    expect($('[data-id=side-nav] li').first()).toBeMatchedBy('.active')
    Dashboard.Sidenav.Display.setButtonInactive(widgetWrapper)
    expect($('[data-id=side-nav] li').first()).not.toBeMatchedBy('.active')

