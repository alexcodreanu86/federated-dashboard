clickOn = (element) ->
  $(element).click()

setupDashboardFixtures = ->
  setFixtures """
    <img data-id="menu-button" src="/lib/icons/hamburger.png" style="width: 75px">
    <div data-id="widget-buttons"></div>
    <div data-id="widget-display">
      <div class="widget-col" data-id="col0-container"></div>
      <div class="widget-col" data-id="col1-container"></div>
      <div class="widget-col" data-id="col2-container"></div>
    </div>
  """

clickMenuButton = ->
  $('[data-id=menu-button]').click()

Dashboard.Widgets.Manager.generateWrappers()

describe "Dashboard.Controller", ->
  describe 'initialize', ->
    it 'is binding the controller', ->
      setupDashboardFixtures()
      Dashboard.Controller.initialize()
      clickMenuButton()
      expect($('[data-id=widget-buttons]').attr('style')).not.toEqual('display: none;')

    it 'is sending the settings to Dashboard.Widgets.Manager', ->
      spy = spyOn(Dashboard.Widgets.Manager, 'generateWrappers')
      data = {default: true}
      Dashboard.Controller.initialize(data)
      expect(spy).toHaveBeenCalledWith(data)

    it 'is generating the wrappers', ->
      Dashboard.Controller.initialize()
      picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
      expect(picturesWrapper).toBeDefined()

    it "is setting the columns height", ->
      setupDashboardFixtures()
      windowHeight = 380
      window.innerHeight = windowHeight
      Dashboard.Controller.initialize()
      columnHeight = $('[data-id=col0-container]').height()
      expect(columnHeight).toEqual(windowHeight)

    it 'binds the sidenav controller', ->
      spy = spyOn Dashboard.Sidenav.Controller, 'bindSetupWidgets'
      Dashboard.Controller.initialize()
      expect(spy).toHaveBeenCalled()

    it 'initializes the display', ->
      spy = spyOn(Dashboard.Display, 'initialize')
      Dashboard.Controller.initialize()
      expect(spy).toHaveBeenCalled()

  describe 'bindMenuButton', ->
    beforeEach ->
      setupDashboardFixtures()
      Dashboard.Controller.initialize()
      clickMenuButton()

    it 'shows the sidenav when the menu button is clicked', ->
      expect($('[data-id=widget-buttons]').attr('style')).not.toEqual("display: none;")

    it 'removes the sidenav when the menu button is clicked and sidenav is displayed already', ->
      clickMenuButton()
      expect($('[data-id=widget-buttons]').attr('style')).toEqual("display: none;")

  describe 'generateDisplaySettings', ->
    it 'assigns the animation speed in the settings', ->
      settings = Dashboard.Controller.generateDisplaySettings({animationSpeed: 300})
      expect(settings.animationSpeed).toBe(300)

    it 'is not assigning animationSpeed when settings are undefined', ->
      settings = Dashboard.Controller.generateDisplaySettings()
      expect(settings.animationSpeed).not.toBeDefined()

  describe 'setupSidenav', ->
    it 'enters widgets edit mode', ->
      spy = spyOn Dashboard.Widgets.Manager, 'enterEditMode'
      Dashboard.Controller.setupSidenav()
      expect(spy).toHaveBeenCalled()

    it 'enables widget sorting', ->
      spy = spyOn(Dashboard.Widgets.Sorter, 'setupSortable')
      Dashboard.Controller.setupSidenav()
      expect(spy).toHaveBeenCalled()

  describe 'removeSidenav', ->
    it 'exits edit mode', ->
      spy = spyOn Dashboard.Widgets.Manager, 'exitEditMode'
      Dashboard.Controller.removeSidenav()
      expect(spy).toHaveBeenCalled()

    it 'disables widget sorting', ->
      spy = spyOn Dashboard.Widgets.Sorter, 'disableSortable'
      Dashboard.Controller.removeSidenav()
      expect(spy).toHaveBeenCalled()
