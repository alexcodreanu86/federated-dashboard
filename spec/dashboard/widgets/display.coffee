setupDashboardFixtures = ->
  setFixtures """
              <div data-id="widget-display">
                <div data-id="col0"></div>
                <div data-id="col1"></div>
                <div data-id="col2"></div>
              </div>
            """

wrappedWidget = new Dashboard.Widgets.Wrapper({widget: Pictures, name: "pictures", numberOfSlots: 3, apiKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"})


clickOn = (element) ->
  $(element).click()

resetSlots = ->
  Dashboard.Widgets.Display.takenSlots.col0 = 0
  Dashboard.Widgets.Display.takenSlots.col1 = 0
  Dashboard.Widgets.Display.takenSlots.col2 = 0

mockActiveWidgetsData = [{container: "#first-container", name: "pictures"}, {container: "#second-container", name: "weather"}]

describe "Dashboard.Widgets.Display", ->
  it "slots are empty in the beggining", ->
    resetSlots()
    expect(Dashboard.Widgets.Display.takenSlots.col0).toEqual(0)
    expect(Dashboard.Widgets.Display.takenSlots.col1).toEqual(0)
    expect(Dashboard.Widgets.Display.takenSlots.col2).toEqual(0)

  it "generateAvailableSlotFor will append a new div in the first col when they are all emtpy",->
    setupDashboardFixtures()
    Dashboard.Widgets.Display.generateAvailableSlotFor(wrappedWidget)
    expect($('[data-id=col0]')).toContainElement('[data-id=pictures-slot]')

  it "generateAvailableSlotFor will append a new div in the second col when the first one doesn't have enough space", ->
    setupDashboardFixtures()
    Dashboard.Widgets.Display.takenSlots.col0 = 3
    Dashboard.Widgets.Display.generateAvailableSlotFor(wrappedWidget)
    expect($('[data-id=col1]')).toContainElement('[data-id=pictures-slot]')
    expect(Dashboard.Widgets.Display.takenSlots.col1).toEqual(3)

  it "generateAvailableSlotFor will append a new div in the third col when the first one doesn't have enough space", ->
    setupDashboardFixtures()
    Dashboard.Widgets.Display.takenSlots.col0 = 3
    Dashboard.Widgets.Display.takenSlots.col1 = 3
    Dashboard.Widgets.Display.generateAvailableSlotFor(wrappedWidget)
    expect($('[data-id=col2]')).toContainElement('[data-id=pictures-slot]')
    expect(Dashboard.Widgets.Display.takenSlots.col2).toEqual(3)

  it "generateAvailableSlotFor will update the slots inside the the col it appends a widget", ->
    setupDashboardFixtures()
    resetSlots()
    Dashboard.Widgets.Display.generateAvailableSlotFor(wrappedWidget)
    expect(Dashboard.Widgets.Display.takenSlots.col0).toEqual(3)

  it "generateAvailableSlotFor will append a new div in the first col when it has enough space", ->
    setupDashboardFixtures()
    Dashboard.Widgets.Display.takenSlots.col0 = 1
    wrappedWidget.numberOfSlots = 2
    Dashboard.Widgets.Display.generateAvailableSlotFor(wrappedWidget)
    expect($('[data-id=col0]')).toContainElement('[data-id=pictures-slot]')
    expect(Dashboard.Widgets.Display.takenSlots.col0).toEqual(3)

  it "generateAvailableSlotFor will not append any div if container can't fit anywhere", ->
    setupDashboardFixtures()
    Dashboard.Widgets.Display.takenSlots.col0 = 1
    Dashboard.Widgets.Display.generateAvailableSlotFor(4, "pictures")
    expect($('[data-id=col0]')).toBeEmpty()
    expect($('[data-id=col1]')).toBeEmpty()
    expect($('[data-id=col2]')).toBeEmpty()

  it "addClosingButtonsFor adds a closing buttons into the containers that are passed to it", ->
    setFixtures("<div id='first-container'></div><div id='second-container'></div>")
    Dashboard.Widgets.Display.addClosingButtonsFor(mockActiveWidgetsData)
    expect($("#first-container")).toContainElement('[data-name=pictures].close-widget')
    expect($("#second-container")).toContainElement('[data-name=weather].close-widget')

  it "removeClosingButtons removes all the closing buttons off the widgets", ->
    setFixtures("<div id='first-container'></div><div id='second-container'></div>")
    Dashboard.Widgets.Display.addClosingButtonsFor(mockActiveWidgetsData)
    expect($("#first-container")).toContainElement('[data-name=pictures].close-widget')
    Dashboard.Widgets.Display.removeClosingButtons()
    expect($("#first-container")).not.toContainElement('[data-name=pictures].close-widget')
    expect($("#second-container")).not.toContainElement('[data-name=weather].close-widget')

