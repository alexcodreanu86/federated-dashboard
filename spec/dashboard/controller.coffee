describe "Dashboard.Controller", ->
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

  newController = (settings)->
    new Dashboard.Controller(settings)

  describe 'initialize', ->
    it 'binds the controller', ->
      setupDashboardFixtures()
      newController().initialize()
      clickMenuButton()
      expect($('[data-id=widget-buttons]').attr('style')).not.toEqual('display: none;')

    it 'sends the settings to Dashboard.Widgets.Manager', ->
      spy = spyOn(Dashboard.Widgets.Manager.prototype, 'generateWrappers')
      data = {default: true}
      newController(data).initialize()
      expect(spy).toHaveBeenCalledWith(data)

    it 'generates the wrappers', ->
      controller = newController()
      controller.initialize()
      picturesWrapper = controller.widgetManager.wrappers.pictures
      expect(picturesWrapper).toBeDefined()

    it "sets the columns height", ->
      setupDashboardFixtures()
      windowHeight = 380
      window.innerHeight = windowHeight
      newController().initialize()
      columnHeight = $('[data-id=col0-container]').height()
      expect(columnHeight).toEqual(windowHeight)

    it 'binds the sidenav controller', ->
      controller = newController()
      spy = spyOn controller.sidenavController, 'bindSetupWidgets'
      controller.initialize()
      expect(spy).toHaveBeenCalled()

    it 'initializes the display', ->
      spy = spyOn(Dashboard.Display.prototype, 'initialize')
      newController().initialize()
      expect(spy).toHaveBeenCalled()

  describe 'bindMenuButton', ->
    beforeEach ->
      setupDashboardFixtures()
      newController().initialize()
      clickMenuButton()

    it 'shows the sidenav when the menu button is clicked', ->
      expect($('[data-id=widget-buttons]').attr('style')).not.toEqual("display: none;")

    it 'removes the sidenav when the menu button is clicked and sidenav is displayed already', ->
      clickMenuButton()
      expect($('[data-id=widget-buttons]').attr('style')).toEqual("display: none;")

  describe 'generateDisplaySettings', ->
    it 'assigns the animation speed in the settings', ->
      controller = newController({animationSpeed: 300})
      settings = controller.generateDisplaySettings()
      expect(settings.animationSpeed).toBe(300)

    it 'does NOT assign animationSpeed when settings are undefined', ->
      controller = newController()
      settings = controller.generateDisplaySettings()
      expect(settings.animationSpeed).not.toBeDefined()

  describe 'setupSidenav', ->
    it 'enters widgets edit mode', ->
      controller = newController()
      controller.initialize()
      spy = spyOn controller.formsManager, 'enterEditMode'
      controller.setupSidenav()
      expect(spy).toHaveBeenCalled()

    it 'enables widget sorting', ->
      controller = newController()
      controller.initialize()
      spy = spyOn(controller.widgetSorter, 'setupSortable')
      controller.setupSidenav()
      expect(spy).toHaveBeenCalled()

  describe 'removeSidenav', ->
    it 'exits edit mode', ->
      controller = newController()
      controller.initialize()
      spy = spyOn controller.formsManager, 'exitEditMode'
      controller.removeSidenav()
      expect(spy).toHaveBeenCalled()

    it 'disables widget sorting', ->
      controller = newController()
      controller.initialize()
      spy = spyOn controller.widgetSorter, 'disableSortable'
      controller.removeSidenav()
      expect(spy).toHaveBeenCalled()
