clickOn = (element) -> $(element).click()

setupDashboardFixtures = ->
  setFixtures """
    <img data-id="menu-button">
    <div data-id="side-nav"></div>
    <div data-id="widget-display">
      <div class="widget-col" data-id='col0-container'><ul class='widget-list' data-id="col0"></ul></div>
      <div class="widget-col" data-id='col1-container'><ul class='widget-list' data-id="col1"></ul></div>
      <div class="widget-col" data-id='col2-container'><ul class='widget-list' data-id="col2"></ul></div>
    </div>
  """

getWidget = (name) ->
  Dashboard.Widgets.Manager.wrappers[name]

resetController = ->
  Dashboard.Controller.initialize()
  resetSlots()

setupAndBindController = ->
  resetSlots()
  Dashboard.Widgets.Manager.generateWrappers()
  setupDashboardFixtures()
  Dashboard.Controller.setupSidenav()
  Dashboard.Sidenav.Controller.rebindButtons()

resetSlots = ->
  Dashboard.Columns.Controller.takenSlots.col0 = 0
  Dashboard.Columns.Controller.takenSlots.col1 = 0
  Dashboard.Columns.Controller.takenSlots.col2 = 0

wrappedWidget = new Dashboard.Widgets.Wrapper({widget: Pictures, name: "pictures", slotSize: 3, apiKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"})

describe "Dashboard.Columns.Controller", ->
  it "slots are empty in the beggining", ->
    resetSlots()
    expect(Dashboard.Columns.Controller.takenSlots.col0).toEqual(0)
    expect(Dashboard.Columns.Controller.takenSlots.col1).toEqual(0)
    expect(Dashboard.Columns.Controller.takenSlots.col2).toEqual(0)

  it "hasEnoughSlots returns true if the column has enough slots", ->
    resetSlots()
    expect(Dashboard.Columns.Controller.hasEnoughSlots('col1', 2)).toBe(true)

  it "hasEnoughSlots returns false if the column doesn't have enough slots", ->
    resetSlots()
    Dashboard.Columns.Controller.takenSlots.col1 = 2
    expect(Dashboard.Columns.Controller.hasEnoughSlots('col1', 2)).toBe(false)

  it "generateAvailableSlotFor will append a new div in the first col when they are all emtpy",->
    resetSlots()
    setupDashboardFixtures()
    Dashboard.Columns.Controller.generateAvailableSlotFor(wrappedWidget)
    expect($('[data-id=col0]')).toContainElement('[data-id=pictures-slot]')

  it "generateAvailableSlotFor will append a new div in the second col when the first one doesn't have enough space", ->
    setupDashboardFixtures()
    Dashboard.Columns.Controller.takenSlots.col0 = 3
    Dashboard.Columns.Controller.generateAvailableSlotFor(wrappedWidget)
    expect($('[data-id=col1]')).toContainElement('[data-id=pictures-slot]')
    expect(Dashboard.Columns.Controller.takenSlots.col1).toEqual(3)

  it "generateAvailableSlotFor will append a new div in the third col when the first one doesn't have enough space", ->
    setupDashboardFixtures()
    Dashboard.Columns.Controller.takenSlots.col0 = 3
    Dashboard.Columns.Controller.takenSlots.col1 = 3
    Dashboard.Columns.Controller.generateAvailableSlotFor(wrappedWidget)
    expect($('[data-id=col2]')).toContainElement('[data-id=pictures-slot]')
    expect(Dashboard.Columns.Controller.takenSlots.col2).toEqual(3)

  it "generateAvailableSlotFor will update the slots inside the the col it appends a widget", ->
    setupDashboardFixtures()
    resetSlots()
    Dashboard.Columns.Controller.generateAvailableSlotFor(wrappedWidget)
    expect(Dashboard.Columns.Controller.takenSlots.col0).toEqual(3)

  it "generateAvailableSlotFor will append a new div in the first col when it has enough space", ->
    setupDashboardFixtures()
    Dashboard.Columns.Controller.takenSlots.col0 = 1
    wrappedWidget.slotSize = 2
    Dashboard.Columns.Controller.generateAvailableSlotFor(wrappedWidget)
    expect($('[data-id=col0]')).toContainElement('[data-id=pictures-slot]')
    expect(Dashboard.Columns.Controller.takenSlots.col0).toEqual(3)

  it "generateAvailableSlotFor will not append any div if container can't fit anywhere", ->
    setupDashboardFixtures()
    Dashboard.Columns.Controller.takenSlots.col0 = 1
    Dashboard.Columns.Controller.generateAvailableSlotFor(4, "pictures")
    expect($('[data-id=col0]')).toBeEmpty()
    expect($('[data-id=col1]')).toBeEmpty()
    expect($('[data-id=col2]')).toBeEmpty()

  it "enableDraggableWidgets on start displays the available containers", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    picturesWrapper = getWidget('pictures')
    spy = spyOn(Dashboard.Columns.Controller, 'activateListsWithAvailableSlots')
    $('[data-id=pictures-slot] .widget-handle').simulate("drag", {dx: 10})
    expect(spy).toHaveBeenCalledWith(picturesWrapper)

  it "enableDraggableWidgets on start enables droppable feature", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    spy = spyOn(Dashboard.Columns.Controller, 'activateDroppable')
    $('[data-id=pictures-slot] .widget-handle').simulate("drag", {dx: 10})
    expect(spy).toHaveBeenCalled()

  it "enableDraggableWidgets on stop removes the zindex and offset properties of the item dropped", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    $('[data-id=pictures-slot] .widget-handle').simulate("drag", {dx: 10})
    expect($('[data-id=pictures-slot]').attr('style')).toEqual('position: relative;')

  it "disableDraggableWidgets is disabling the draggable feature", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    Dashboard.Columns.Controller.disableDraggableWidgets()
    spy = spyOn(Dashboard.Columns.Controller, 'activateListsWithAvailableSlots')
    $('[data-id=pictures-slot] .widget-handle').simulate("drag", {dx: 10})
    expect(spy).not.toHaveBeenCalled()

  it "activateListsWithAvailableSlots displays the lists with available slots", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    picturesWrapper = getWidget('pictures')
    Dashboard.Columns.Controller.takenSlots.col1 = 3
    Dashboard.Columns.Controller.activateListsWithAvailableSlots(picturesWrapper)
    expect($('[data-id=col0-container]')).toBeMatchedBy('.droppable-column')
    expect($('[data-id=col1-container]')).not.toBeMatchedBy('.droppable-column')
    expect($('[data-id=col2-container]')).toBeMatchedBy('.droppable-column')

  it "processDroppedWidgetIn is updating the widgets container", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    picturesWrapper = getWidget('pictures')
    Dashboard.Columns.Controller.processDroppedWidgetIn(picturesWrapper, 'col1')
    expect(picturesWrapper.containerColumn).toEqual('col1')

  it "processDroppedWidgetIn updates the taken Slots", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    picturesWrapper = getWidget('pictures')
    Dashboard.Columns.Controller.processDroppedWidgetIn(picturesWrapper, 'col1')
    expect(Dashboard.Columns.Controller.takenSlots.col0).toEqual(0)
    expect(Dashboard.Columns.Controller.takenSlots.col1).toEqual(picturesWrapper.slotSize)

  it "enableSortableColumns is enabling column sorting", ->
    setupDashboardFixtures()
    Dashboard.Columns.Controller.enableSortableColumns()
    expect($('.widget-list')).toBeMatchedBy('.ui-sortable')

  it "disableSortableColumns is disabling column sorting", ->
    setupDashboardFixtures()
    Dashboard.Columns.Controller.enableSortableColumns()
    Dashboard.Columns.Controller.disableSortableColumns()
    expect($('.widget-list')).not.toBeMatchedBy('.ui-sortable')

  it "enterEditMode is enabling draggable widgets and sortable columns", ->
    setupDashboardFixtures()
    dragSpy = spyOn(Dashboard.Columns.Controller, 'enableDraggableWidgets')
    sortSpy = spyOn(Dashboard.Columns.Controller, 'enableSortableColumns')
    Dashboard.Columns.Controller.enterEditMode()
    expect(dragSpy).toHaveBeenCalled()
    expect(sortSpy).toHaveBeenCalled()

  it "exitEditMode disables the draggable and sortable feature", ->
    setupDashboardFixtures()
    dragSpy = spyOn(Dashboard.Columns.Controller, 'disableDraggableWidgets')
    sortSpy = spyOn(Dashboard.Columns.Controller, 'disableSortableColumns')
    Dashboard.Columns.Controller.exitEditMode()
    expect(dragSpy).toHaveBeenCalled()
    expect(sortSpy).toHaveBeenCalled()

  it "resetSortableColumns is reseting the sortable columns", ->
    setupDashboardFixtures()
    disableSpy = spyOn(Dashboard.Columns.Controller, 'disableSortableColumns')
    enableSpy = spyOn(Dashboard.Columns.Controller, 'enableSortableColumns')
    Dashboard.Columns.Controller.resetSortableColumns()
    expect(disableSpy).toHaveBeenCalled()
    expect(enableSpy).toHaveBeenCalled()
