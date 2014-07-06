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
  Dashboard.Widgets.Display.takenSlots.col0 = 0
  Dashboard.Widgets.Display.takenSlots.col1 = 0
  Dashboard.Widgets.Display.takenSlots.col2 = 0

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
    clickOn('[data-id=pictures-widget]')
    Dashboard.Controller.removeSidenav()
    Dashboard.Controller.setupSidenav()
    picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    expect($(picturesWrapper.containerName)).toContainElement('[data-name=pictures].close-widget')

  it "removeSidenav closes edit mode", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    Dashboard.Controller.removeSidenav()
    Dashboard.Controller.setupSidenav()
    picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    expect($(picturesWrapper.containerName)).toContainElement('[data-name=pictures].close-widget')
    Dashboard.Controller.removeSidenav()
    expect($(picturesWrapper.containerName)).not.toContainElement('[data-name=pictures].close-widget')
