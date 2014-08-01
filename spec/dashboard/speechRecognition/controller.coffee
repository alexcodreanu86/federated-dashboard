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

prepareDashboard = ->
  setupDashboardFixtures()
  Dashboard.Controller.initialize()


describe "Dashboard.SpeechRecognition.Controller", ->
 it "showSidenav displays the sidenav", ->
    spy = spyOn(Dashboard.Controller, 'setupSidenav')
    Dashboard.SpeechRecognition.Controller.showSidenav()
    expect(spy).toHaveBeenCalled()

  it "removeSidenav is removing the sidenav", ->
    spy = spyOn(Dashboard.Controller, 'removeSidenav')
    Dashboard.SpeechRecognition.Controller.removeSidenav()
    expect(spy).toHaveBeenCalled()

  it "searchWidgetFor searches the widget with the given input", ->
    prepareDashboard()
    Dashboard.Controller.setupSidenav()
    clickOn('[data-id=pictures-widget]')
    $('[data-id=pictures-button]').unbind('click')
    Dashboard.SpeechRecognition.Controller.searchWidgetFor('pictures', "bikes")
    expect($('[name=pictures-search]').val()).toEqual('bikes')

  it "openWidget will open the widget that is passed to it", ->
    prepareDashboard()
    Dashboard.Controller.setupSidenav()
    Dashboard.SpeechRecognition.Controller.openWidget('pictures')
    expect($('[data-id=col0]')).toContainElement('[data-id=pictures-button]')

  it "closeWidget is closing the widget", ->
    prepareDashboard()
    Dashboard.Controller.setupSidenav()
    Dashboard.SpeechRecognition.Controller.openWidget('weather')
    Dashboard.SpeechRecognition.Controller.closeWidget('weather')
    expect($('[data-id=col0]')).not.toContainElement('[data-id=pictures-button]')

  xit "dragWidget will drag the widget to the right when direction is right", ->
    spy = spyOn(Dashboard.SpeechRecognition.Controller, 'dragRight')
    Dashboard.SpeechRecognition.Controller.dragWidget('pictures', 'right')
    expect(spy).toHaveBeenCalledWith('pictures')

  xit "dragWidget will drag the widget to the left when direction is left", ->
    spy = spyOn(Dashboard.SpeechRecognition.Controller, 'dragLeft')
    Dashboard.SpeechRecognition.Controller.dragWidget('pictures', 'left')
    expect(spy).toHaveBeenCalledWith('pictures')

  xit "dragWidget will drag the widget to the down when direction is down", ->
    spy = spyOn(Dashboard.SpeechRecognition.Controller, 'dragDown')
    Dashboard.SpeechRecognition.Controller.dragWidget('pictures', 'down')
    expect(spy).toHaveBeenCalledWith('pictures')

  xit "dragWidget will drag the widget to the left when direction is up", ->
    spy = spyOn(Dashboard.SpeechRecognition.Controller, 'dragUp')
    Dashboard.SpeechRecognition.Controller.dragWidget('pictures', 'up')
    expect(spy).toHaveBeenCalledWith('pictures')
