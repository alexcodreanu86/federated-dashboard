wrappedWidget = new Dashboard.Widgets.Wrapper({widget: Pictures, name: "pictures", numberOfSlots: 3, apiKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"})

Dashboard.Widgets.Manager.generateWrappers()
buttons = Dashboard.Widgets.Manager.getSidenavButtons()

setupSidenav = ->
  setupDashboardFixtures()
  Dashboard.Display.initialize(buttons: buttons)

setSidenavContainer = ->
  setFixtures "<div data-id='widget-buttons'></div>"

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

buttonsContainer = '[data-id=widget-buttons]'

clickOn = (element) ->
  $(element).click()

getColumnHeight = (col) ->
  $("[data-id=#{col}-container]").height()

describe 'Dashboard.Display', ->
  it "setupSidenav displays the sideNav", ->
    setupSidenav()
    expect($(buttonsContainer)).toContainElement('[data-id=pictures-widget]')
    expect($(buttonsContainer)).toContainElement('[data-id=weather-widget]')
    expect($(buttonsContainer)).toContainElement('[data-id=stock-widget]')
    expect($(buttonsContainer)).toContainElement('[data-id=twitter-widget]')

  it "hideSidenav removes the sidenav of the screen", ->
    setupSidenav()
    Dashboard.Display.hideSidenav()
    expect($(buttonsContainer).attr('style')).toEqual('display: none;')

  describe "isSidenavDisplayed", ->
    it "isSidenavDisplayed returns false if sidenav is not displayed", ->
      setupSidenav()
      expect(Dashboard.Display.isSidenavDisplayed()).toBe(false)

    it "isSidenavDisplayed returns true if sidenav is displayed", ->
      setupSidenav()
      Dashboard.Display.showSidenav()
      expect(Dashboard.Display.isSidenavDisplayed()).toBe(true)

  describe "initialize", ->
    it "is setting the height to equal container height", ->
      setupDashboardFixtures()
      windowHeight = 400
      window.innerHeight = windowHeight
      Dashboard.Display.initialize(buttons: buttons)
      expect(getColumnHeight('col1')).toEqual(400)
      expect(getColumnHeight('col1')).toEqual(400)
      expect(getColumnHeight('col2')).toEqual(400)

    it "is updating the column height when window is resized", ->
      setupDashboardFixtures()
      window.innerHeight = 400
      Dashboard.Display.initialize(buttons: buttons)
      window.innerHeight = 380
      $(window).trigger('resize')
      expect(getColumnHeight('col1')).toEqual(380)

    it "is hiding the widget-buttons", ->
      setupDashboardFixtures()
      Dashboard.Display.initialize(buttons: buttons)
      expect($('[data-id=widget-buttons]').attr('style')).toEqual('display: none;')

    it "is setting up the sidenav", ->
      setupDashboardFixtures()
      Dashboard.Display.initialize(buttons: buttons)
      expect($('[data-id=widget-buttons]')).not.toBeEmpty()

    it "assigns the animationSpeed to the value given", ->
      setupDashboardFixtures()
      Dashboard.Display.initialize({buttons: buttons, animationSpeed: 300})
      expect(Dashboard.Display.animationSpeed).toBe(300)
