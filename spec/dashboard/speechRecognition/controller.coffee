describe "Dashboard.SpeechRecognition.Controller", ->
  setupDashboardFixtures = ->
    setFixtures """
      <img data-id="menu-button">
      <div data-id="widget-buttons"></div>
      <div data-id="widget-display">
        <div class="widget-col" data-id='col0-container'><ul class='widget-list' data-id="col0"></ul></div>
        <div class="widget-col" data-id='col1-container'><ul class='widget-list' data-id="col1"></ul></div>
        <div class="widget-col" data-id='col2-container'><ul class='widget-list' data-id="col2"></ul></div>
      </div>
    """

  clickOn = (element) -> $(element).click()

  prepareDashboard = (controller) ->
    setupDashboardFixtures()
    controller.dashboardController.initialize()

  newController = ->
    new Dashboard.SpeechRecognition.Controller(new Dashboard.Controller)

  it "showSidenav displays the sidenav", ->
    controller = newController()
    spy = spyOn(controller.dashboardController, 'setupSidenav')
    controller.showSidenav()
    expect(spy).toHaveBeenCalled()

  it "removeSidenav is removing the sidenav", ->
    controller = newController()
    spy = spyOn(controller.dashboardController, 'removeSidenav')
    controller.removeSidenav()
    expect(spy).toHaveBeenCalled()

  it "searchWidgetFor searches the widget with the given input", ->
    controller = newController()
    prepareDashboard(controller)
    clickOn('[data-id=pictures-widget]')
    $('[data-id=pictures-button]').unbind('click')
    controller.searchWidgetFor('pictures', "bikes")
    expect($('[name=pictures-search]').val()).toEqual('bikes')

  it "openWidget will open the widget that is passed to it", ->
    controller = newController()
    prepareDashboard(controller)
    controller.dashboardController.setupSidenav()
    controller.openWidget('pictures')
    expect($('[data-id=col0]')).toContainElement('[data-id=pictures-button]')

  it "closeWidget is closing the widget", ->
    controller = newController()
    prepareDashboard(controller)
    controller.dashboardController.setupSidenav()
    controller.openWidget('weather')
    controller.closeWidget('weather')
    expect($('[data-id=col0]')).not.toContainElement('[data-id=pictures-button]')

  xit "dragWidget will drag the widget to the right when direction is right", ->
    controller = newController()
    spy = spyOn(controller, 'dragRight')
    controller.dragWidget('pictures', 'right')
    expect(spy).toHaveBeenCalledWith('pictures')

  xit "dragWidget will drag the widget to the left when direction is left", ->
    controller = newController()
    spy = spyOn(controller, 'dragLeft')
    controller.dragWidget('pictures', 'left')
    expect(spy).toHaveBeenCalledWith('pictures')

  xit "dragWidget will drag the widget to the down when direction is down", ->
    controller = newController()
    spy = spyOn(controller, 'dragDown')
    controller.dragWidget('pictures', 'down')
    expect(spy).toHaveBeenCalledWith('pictures')

  xit "dragWidget will drag the widget to the left when direction is up", ->
    controller = newController()
    spy = spyOn(controller, 'dragUp')
    controller.dragWidget('pictures', 'up')
    expect(spy).toHaveBeenCalledWith('pictures')
