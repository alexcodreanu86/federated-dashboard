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
