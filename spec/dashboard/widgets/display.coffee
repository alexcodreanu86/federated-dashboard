mockActiveWidgetsData = [{container: "#first-container", name: "pictures"}, {container: "#second-container", name: "weather"}]

setupFixtures = ->
    setFixtures("""
      <div id='first-container'><div class='widget-title'></div></div>
      <div id='second-container'><div class='widget-title'></div></div>
    """)

describe "Dashboard.Widgets.Display", ->
  it "addEditindButtonsFor adds closing buttons into the containers that are passed to it", ->
    setupFixtures()
    Dashboard.Widgets.Display.addEditingButtonsFor(mockActiveWidgetsData)
    expect($("#first-container")).toContainElement('[data-name=pictures].widget-close')
    expect($("#second-container")).toContainElement('[data-name=weather].widget-close')

  it "addEditingButtonsFor adds dragging handles into the containers that are passed to it", ->
    setupFixtures()
    Dashboard.Widgets.Display.addEditingButtonsFor(mockActiveWidgetsData)
    expect($("#first-container")).toContainElement('[data-name=pictures].widget-handle')
    expect($("#second-container")).toContainElement('[data-name=weather].widget-handle')

  it "removeClosingButtons removes all the closing buttons off the widgets", ->
    setupFixtures()
    Dashboard.Widgets.Display.addEditingButtonsFor(mockActiveWidgetsData)
    expect($("#first-container")).toContainElement('[data-name=pictures].widget-close')
    Dashboard.Widgets.Display.removeClosingButtons()
    expect($("#first-container")).not.toContainElement('[data-name=pictures].widget-close')
    expect($("#second-container")).not.toContainElement('[data-name=weather].widget-close')

  it "removeDraggingHandles removes all the dragging handles", ->
    setFixtures("<div id='first-container'></div><div id='second-container'></div>")
    Dashboard.Widgets.Display.addEditingButtonsFor(mockActiveWidgetsData)
    expect($("#first-container")).toContainElement('[data-name=pictures].widget-handle')
    Dashboard.Widgets.Display.removeDraggingHandles()
    expect($("#first-container")).not.toContainElement('[data-name=pictures].widget-handle')
    expect($("#second-container")).not.toContainElement('[data-name=weather].widget-handle')
