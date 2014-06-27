setupDashboardFixtures = ->
  setFixtures """
              <div data-id="widget-display">
                <div data-id="col0"></div>
                <div data-id="col1"></div>
                <div data-id="col2"></div>
              </div>
            """

wrappedWidget = new Dashboard.WidgetWrapper({widget: Pictures, name: "pictures", numberOfSlots: 3, apiKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"})

buttons = Dashboard.Controller.getSidenavButtons()

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

  it "populateWidget adds html to the widget display container", ->
    setupDashboardFixtures()
    Dashboard.Display.populateWidget('<h1>Hello world</h1>')
    expect($('[data-id=widget-display]').html()).toEqual('<h1>Hello world</h1>')

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

  it "slots are empty on in the beggining", ->
    resetSlots()
    expect(Dashboard.Display.takenSlots.col0).toEqual(0)
    expect(Dashboard.Display.takenSlots.col1).toEqual(0)
    expect(Dashboard.Display.takenSlots.col2).toEqual(0)

  it "generateAvailableSlotFor will append a new div in the first col when they are all emtpy",->
    setupDashboardFixtures()
    Dashboard.Display.generateAvailableSlotFor(wrappedWidget)
    expect($('[data-id=col0]')).toContainElement('[data-id=pictures-slot]')

  it "generateAvailableSlotFor will append a new div in the second col when the first one doesn't have enough space", ->
    setupDashboardFixtures()
    Dashboard.Display.takenSlots.col0 = 3
    Dashboard.Display.generateAvailableSlotFor(wrappedWidget)
    expect($('[data-id=col1]')).toContainElement('[data-id=pictures-slot]')
    expect(Dashboard.Display.takenSlots.col1).toEqual(3)

  it "generateAvailableSlotFor will append a new div in the third col when the first one doesn't have enough space", ->
    setupDashboardFixtures()
    Dashboard.Display.takenSlots.col0 = 3
    Dashboard.Display.takenSlots.col1 = 3
    Dashboard.Display.generateAvailableSlotFor(wrappedWidget)
    expect($('[data-id=col2]')).toContainElement('[data-id=pictures-slot]')
    expect(Dashboard.Display.takenSlots.col2).toEqual(3)

  it "generateAvailableSlotFor will update the slots inside the the col it appends a widget", ->
    setupDashboardFixtures()
    resetSlots()
    Dashboard.Display.generateAvailableSlotFor(wrappedWidget)
    expect(Dashboard.Display.takenSlots.col0).toEqual(3)

  it "generateAvailableSlotFor will append a new div in the first col when it has enough space", ->
    setupDashboardFixtures()
    Dashboard.Display.takenSlots.col0 = 1
    wrappedWidget.numberOfSlots = 2
    Dashboard.Display.generateAvailableSlotFor(wrappedWidget)
    expect($('[data-id=col0]')).toContainElement('[data-id=pictures-slot]')
    expect(Dashboard.Display.takenSlots.col0).toEqual(3)

  it "generateAvailableSlotFor will not append any div if container can't fit anywhere", ->
    setupDashboardFixtures()
    Dashboard.Display.takenSlots.col0 = 1
    Dashboard.Display.generateAvailableSlotFor(4, "pictures")
    expect($('[data-id=col0]')).toBeEmpty()
    expect($('[data-id=col1]')).toBeEmpty()
    expect($('[data-id=col2]')).toBeEmpty()


