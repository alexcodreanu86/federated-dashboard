wrappedWidget = new Dashboard.Widgets.Wrapper({widget: Pictures, name: "pictures", numberOfSlots: 3, apiKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"})
manager = new Dashboard.Widgets.Manager

manager.generateWrappers()
buttons = manager.getSidenavButtons()

initializedDisplay = ->
  display = newDisplay(buttons)
  display.initialize()
  display


newDisplay = (buttons, animationSpeed) ->
  new Dashboard.Display(buttons: buttons, animationSpeed: animationSpeed)

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
    setupDashboardFixtures()
    initializedDisplay()
    expect($(buttonsContainer)).toContainElement('[data-id=pictures-widget]')
    expect($(buttonsContainer)).toContainElement('[data-id=weather-widget]')
    expect($(buttonsContainer)).toContainElement('[data-id=twitter-widget]')

  it "hideSidenav removes the sidenav of the screen", ->
    setupDashboardFixtures()
    display = initializedDisplay()
    display.hideSidenav()
    expect($(buttonsContainer).attr('style')).toEqual('display: none;')

  describe "isSidenavDisplayed", ->
    it "isSidenavDisplayed returns false if sidenav is not displayed", ->
      setupDashboardFixtures()
      display = initializedDisplay()
      expect(display.isSidenavDisplayed()).toBe(false)

    it "isSidenavDisplayed returns true if sidenav is displayed", ->
      setupDashboardFixtures()
      display = initializedDisplay()
      display.showSidenav()
      expect(display.isSidenavDisplayed()).toBe(true)

  describe "initialize", ->
    it "is setting the height to equal container height", ->
      setupDashboardFixtures()
      windowHeight = 400
      window.innerHeight = windowHeight
      initializedDisplay()
      expect(getColumnHeight('col1')).toEqual(400)
      expect(getColumnHeight('col1')).toEqual(400)
      expect(getColumnHeight('col2')).toEqual(400)

    it "is updating the column height when window is resized", ->
      setupDashboardFixtures()
      window.innerHeight = 400
      initializedDisplay()
      window.innerHeight = 380
      $(window).trigger('resize')
      expect(getColumnHeight('col1')).toEqual(380)

    it "is hiding the widget-buttons", ->
      setupDashboardFixtures()
      initializedDisplay()
      expect($('[data-id=widget-buttons]').attr('style')).toEqual('display: none;')

    it "is setting up the sidenav", ->
      setupDashboardFixtures()
      initializedDisplay()
      expect($('[data-id=widget-buttons]')).not.toBeEmpty()

    it "assigns the animationSpeed to the value given", ->
      setupDashboardFixtures()
      display = newDisplay(buttons, 300)
      expect(display.animationSpeed).toBe(300)
