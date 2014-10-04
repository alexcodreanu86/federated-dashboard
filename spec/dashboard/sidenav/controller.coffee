clickOn = (element) ->
  $(element).click()

setupDashboardFixtures = ->
  setFixtures """
    <img data-id="menu-button" src="/lib/icons/hamburger.png" style="width: 75px">
    <div data-id="widget-buttons"></div>
    <div data-id="widget-display">
      <div class="widget-col" data-id="col0"></div>
      <div class="widget-col" data-id="col1"></div>
      <div class="widget-col" data-id="col2"></div>
    </div>
  """

describe "Dasbboard.Sidenav.Controller", ->
  it 'bindSetupWidgets is setting up the widget of the button clicked', ->
    setupDashboardFixtures()
    mainController = new Dashboard.Controller()
    mainController.initialize()
    mainController.setupSidenav()
    clickOn('[data-id=pictures-widget]')
    expect($('[data-id=col0]')).not.toBeEmpty()

  it 'getWidgetName returns pictures for the pictures button', ->
    controller = new Dashboard.Sidenav.Controller
    name = controller.getWidgetName('pictures-widget')
    expect(name).toEqual('pictures')
