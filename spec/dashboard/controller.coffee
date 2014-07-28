clickOn = (element) ->
  $(element).click()

setupDashboardFixtures = ->
  setFixtures """
    <img data-id="menu-button" src="/lib/icons/hamburger.png" style="width: 75px">
    <div data-id="side-nav"></div>
    <div data-id="widget-display">
      <div class="widget-col" data-id="col0"></div>
      <div class="widget-col" data-id="col1"></div>
      <div class="widget-col" data-id="col2"></div>
    </div>
  """

resetController = ->
  Dashboard.Controller.initialize()
  resetSlots()

setupAndBindController = ->
  resetController()
  Dashboard.Widgets.Manager.generateWrappers()
  setupDashboardFixtures()
  Dashboard.Controller.setupSidenav()

assertSidenavGetsLoaded = ->
  setFixtures "<image data-id='menu-button'/><div data-id='side-nav'></div>"
  resetController()
  clickOn('[data-id=menu-button]')
  expect($('[data-id=side-nav]')).toContainElement('[data-id=pictures-widget]')
  expect($('[data-id=side-nav]')).toContainElement('[data-id=weather-widget]')
  expect($('[data-id=side-nav]')).toContainElement('[data-id=stock-widget]')
  expect($('[data-id=side-nav]')).toContainElement('[data-id=twitter-widget]')

resetSlots = ->
  Dashboard.Columns.Controller.takenSlots.col0 = 0
  Dashboard.Columns.Controller.takenSlots.col1 = 0
  Dashboard.Columns.Controller.takenSlots.col2 = 0

describe "Dashboard.Controller", ->
  it "toggleSidenav displays the side-nav when the menu button is clicked", ->
    assertSidenavGetsLoaded()

  it "toggleSidenav removes the side-nav when menu-button is clicked and side-nav is on the screen", ->
    assertSidenavGetsLoaded()
    clickOn('[data-id=menu-button]')
    expect($('[data-id=side-nav]')).toBeEmpty()

  it "setupSidenav enables widget editing", ->
    setupAndBindController()
    spy = spyOn(Dashboard.Widgets.Manager, 'showActiveForms')
    clickOn('[data-id=weather-widget]')
    Dashboard.Controller.removeSidenav()
    Dashboard.Controller.setupSidenav()
    weatherWrapper = Dashboard.Widgets.Manager.wrappers.weather
    expect($(weatherWrapper.containerName)).toContainElement('.widget-close')

  it "setupSidenav enables columns editing", ->
    setupDashboardFixtures()
    spy = spyOn(Dashboard.Columns.Controller, 'enterEditMode')
    Dashboard.Controller.setupSidenav()
    expect(spy).toHaveBeenCalled()

  it "removeSidenav closes edit mode", ->
    setupAndBindController()
    clickOn('[data-id=weather-widget]')
    Dashboard.Controller.removeSidenav()
    Dashboard.Controller.setupSidenav()
    weatherWrapper = Dashboard.Widgets.Manager.wrappers.weather
    expect($(weatherWrapper.containerName)).toContainElement('.widget-close')
    Dashboard.Controller.removeSidenav()
    expect($("#{weatherWrapper.containerName} .widget-close").attr('style')).toEqual('display: none;')

  it "removeSidenav disables columns editing", ->
    setupDashboardFixtures()
    Dashboard.Controller.setupSidenav()
    spy = spyOn(Dashboard.Columns.Controller, 'exitEditMode')
    Dashboard.Controller.removeSidenav()
    expect(spy).toHaveBeenCalled()

