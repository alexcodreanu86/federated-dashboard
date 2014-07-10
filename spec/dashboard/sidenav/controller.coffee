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
  resetSlots()
  Dashboard.Widgets.Manager.generateWrappers()
  setupDashboardFixtures()
  Dashboard.Controller.setupSidenav()
  Dashboard.Sidenav.Controller.bindButtons()

resetSlots = ->
  Dashboard.Columns.Controller.takenSlots.col0 = 0
  Dashboard.Columns.Controller.takenSlots.col1 = 0
  Dashboard.Columns.Controller.takenSlots.col2 = 0

describe "Dasbboard.Sidenav.Controller", ->
  it "bindButtons displays the form for pictures when the pictures button is clicked", ->
    setupAndBindController()
    clickOn('[data-id=pictures-widget]')
    expect($('[data-id=pictures-button]')).toBeInDOM()

  it "bindButtons displays the form for weather when the weather button is clicked", ->
    setupAndBindController()
    clickOn('[data-id=weather-widget]')
    expect($('[data-id=weather-button]')).toBeInDOM()

  it "bindButtons displays the form for stocks when the stock button is clicked", ->
    setupAndBindController()
    clickOn('[data-id=stock-widget]')
    expect($('[data-id=stock-button]')).toBeInDOM()

  it "unbind unbinds all click bindings", ->
    setupAndBindController()
    Dashboard.Sidenav.Controller.unbind()
    clickOn('[data-id=pictures-widget]')
    expect($('[data-id=pictures-button]')).not.toBeInDOM()

