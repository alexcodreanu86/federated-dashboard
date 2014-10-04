setupDashboardFixtures = ->
  setFixtures """
    <img data-id="menu-button">
    <div data-id="side-nav"></div>
    <div data-id="widget-display">
      <div class="widget-col"><ul class='widget-list' data-id="col0"></ul></div>
      <div class="widget-col"><ul class='widget-list' data-id="col1"></ul></div>
      <div class="widget-col"><ul class='widget-list' data-id="col2"></ul></div>
    </div>
  """

getWrapper = (manager, name) ->
  manager.wrappers[name]

newManager = (settings) ->
  new Dashboard.Widgets.Manager(settings)

describe "Dashboard.Widgets.Manager", ->
  it "wrapWidget returns a new widgetWrapper", ->
    manager = newManager()
    wrapper = manager.wrapWidget({widget: Pictures, name: "pictures", slotSize: "L", key: "some-api-key"})
    expect(wrapper.name).toEqual("pictures")
    expect(wrapper.slotSize).toEqual(3)
    expect(wrapper.widget).toEqual(Pictures)

  it "wraps several widgets wrappers", ->
    manager = newManager()
    manager.generateWrappers()
    widgets = _.keys(manager.wrappers)
    expect(widgets.length > 2 ).toBe(true)

  it "getSidenavButtons returns the buttons for all widgets", ->
    setFixtures sandbox()
    manager = newManager()
    manager.generateWrappers()
    buttons = manager.getSidenavButtons()
    $('#sandbox').html(buttons)
    expect($('#sandbox')).toContainElement('[data-id=pictures-widget]')
    expect($('#sandbox')).toContainElement('[data-id=weather-widget]')
    expect($('#sandbox')).toContainElement('[data-id=twitter-widget]')

  describe 'setupWidget', ->
    beforeEach ->
      setupDashboardFixtures()

    it 'is setting up the pictures widget for pictures', ->
      manager = newManager()
      manager.generateWrappers()
      manager.setupWidget('pictures')
      expect($('[data-id=col0]')).toContainElement('[data-id=pictures-widget-wrapper]')

    it 'is not setting up the pictures widget when container is not valid', ->
      manager = newManager()
      manager.generateWrappers()
      spyOn(Dashboard.Widgets.Display, 'generateContainer').and.returnValue(undefined)
      manager.setupWidget('pictures')
      expect($('[data-id=pictures-widget-wrapper]')).not.toBeInDOM()

  describe 'generateWrappers', ->
    it 'adds default values to widgets when settings.defaults is true', ->
      manager = newManager()
      manager.generateWrappers({defaults: true})
      weatherWrapper = getWrapper(manager, 'weather')
      expect(weatherWrapper.defaultValue).toEqual('Chicago IL')

    it 'doesn\'t add default values to widgets when settings are not provided', ->
      manager = newManager()
      manager.generateWrappers()
      weatherWrapper = getWrapper(manager, 'weather')
      expect(weatherWrapper.defaultValue).not.toBeDefined()
