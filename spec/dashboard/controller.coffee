clickOn = (element) ->
  $(element).click()

setupDashboardFixtures = ->
  setFixtures """
    <img data-id="menu-button" src="/lib/icons/hamburger.png" style="width: 75px">
    <div data-id="side-nav"></div>
  """

clickMenuButton = ->
  $('[data-id=menu-button]').click()

Dashboard.Widgets.Manager.generateWrappers()

describe "Dashboard.Controller", ->
  describe 'initialize', ->
    it 'is binding the controller', ->
      spy = spyOn(Dashboard.Controller, 'bindMenuButton')
      Dashboard.Controller.initialize()
      expect(spy).toHaveBeenCalled()

    it 'is sending the settings to Dashboard.Widgets.Manager', ->
      spy = spyOn(Dashboard.Widgets.Manager, 'generateWrappers')
      data = {default: true}
      Dashboard.Controller.initialize(data)
      expect(spy).toHaveBeenCalledWith(data)

    it 'is generating the wrappers', ->
      Dashboard.Controller.initialize()
      picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
      expect(picturesWrapper).toBeDefined()

  describe 'bindMenuButton', ->
    beforeEach ->
      setupDashboardFixtures()
      Dashboard.Controller.bindMenuButton()
      clickMenuButton()

    it 'shows the sidenav when the menu button is clicked', ->
      expect($('[data-id=pictures-widget]')).toBeInDOM()

    it 'removes the sidenav when the menu button is clicked and sidenav is displayed already', ->
      clickMenuButton()
      expect($('[data-id=pictures-widget]')).not.toBeInDOM()

  describe 'setupSidenav', ->
    it 'binds the sidenav controller', ->
      spy = spyOn Dashboard.Sidenav.Controller, 'bindSetupWidgets'
      Dashboard.Controller.setupSidenav()
      expect(spy).toHaveBeenCalled()

    it 'enters widgets edit mode', ->
      spy = spyOn Dashboard.Widgets.Manager, 'enterEditMode'
      Dashboard.Controller.setupSidenav()
      expect(spy).toHaveBeenCalled()

    it 'enabls widget sorting', ->
      spy = spyOn(Dashboard.Widgets.Sorter, 'setupSortable')
      Dashboard.Controller.setupSidenav()
      expect(spy).toHaveBeenCalled()

    it 'gets the buttons the first time it is setup', ->
      Dashboard.Widgets.Manager.generateWrappers()
      Dashboard.Controller.sidenavButtons = undefined
      spy = spyOn(Dashboard.Widgets.Manager, 'getSidenavButtons').and.callThrough()
      Dashboard.Controller.setupSidenav()
      expect(spy).toHaveBeenCalled()

    it 'doesn\'t request the buttons if they have been requested already', ->
      Dashboard.Widgets.Manager.generateWrappers()
      Dashboard.Controller.setupSidenav()
      Dashboard.Controller.removeSidenav()
      spy = spyOn(Dashboard.Widgets.Manager, 'getSidenavButtons').and.callThrough()
      Dashboard.Controller.setupSidenav()
      expect(spy).not.toHaveBeenCalled()


  describe 'removeSidenav', ->
    it 'exits edit mode', ->
      spy = spyOn Dashboard.Widgets.Manager, 'exitEditMode'
      Dashboard.Controller.removeSidenav()
      expect(spy).toHaveBeenCalled()

    it 'disables widget sorting', ->
      spy = spyOn Dashboard.Widgets.Sorter, 'disableSortable'
      Dashboard.Controller.removeSidenav()
      expect(spy).toHaveBeenCalled()
