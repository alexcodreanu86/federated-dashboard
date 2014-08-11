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

getWrapper = (name) ->
  Dashboard.Widgets.Manager.wrappers[name]

describe "Dashboard.Widgets.Manager", ->
  it "wrapWidget returns a new widgetWrapper", ->
    wrapper = Dashboard.Widgets.Manager.wrapWidget({widget: Pictures, name: "pictures", slotSize: 3, key: "some-api-key"})
    expect(wrapper.name).toEqual("pictures")
    expect(wrapper.slotSize).toEqual(3)
    expect(wrapper.widget).toEqual(Pictures)

  it "wrappers several widgets wrappers", ->
    Dashboard.Widgets.Manager.generateWrappers()
    widgets = _.keys(Dashboard.Widgets.Manager.wrappers)
    expect(widgets.length > 4 ).toBe(true)

  it "getSidenavButtons returns the buttons for all widgets", ->
    Dashboard.Widgets.Manager.generateWrappers()
    buttons = Dashboard.Widgets.Manager.getSidenavButtons()
    expect(buttons[0]).toBeMatchedBy('[data-id=pictures-widget]')
    expect(buttons[1]).toBeMatchedBy('[data-id=weather-widget]')
    expect(buttons[2]).toBeMatchedBy('[data-id=twitter-widget]')
    expect(buttons[3]).toBeMatchedBy('[data-id=stock-widget]')

  describe 'setupWidget', ->
    beforeEach ->
      setupDashboardFixtures()

    it 'is setting up the pictures widget for pictures', ->
      Dashboard.Widgets.Manager.generateWrappers()
      Dashboard.Widgets.Manager.setupWidget('pictures')
      expect($('[data-id=col0]')).toContainElement('[data-id=pictures-widget-wrapper]')

    it 'is not setting up the pictures widget when container is not valid', ->
      spyOn(Dashboard.Widgets.Display, 'generateContainer').and.returnValue(undefined)
      Dashboard.Widgets.Manager.setupWidget('pictures')
      expect($('[data-id=pictures-widget-wrapper]')).not.toBeInDOM()

  describe 'generateWrappers', ->
    it 'adds default values to widgets when settings.defaults is true', ->
      Dashboard.Widgets.Manager.generateWrappers({defaults: true})
      weatherWrapper = getWrapper('weather')
      expect(weatherWrapper.defaultValue).toEqual('Chicago IL')

    it 'doesn\'t add default values to widgets when settings are not provided', ->
      Dashboard.Widgets.Manager.generateWrappers()
      weatherWrapper = getWrapper('weather')
      expect(weatherWrapper.defaultValue).not.toBeDefined()

  describe 'editMode', ->
    beforeEach ->
      setupDashboardFixtures()
      Dashboard.Widgets.Manager.setupWidget('pictures')
      Dashboard.Widgets.Manager.exitEditMode()

    it 'exitEditMode is hiding the widgets\' forms', ->
      picturesCloseButton = $('[data-id=pictures-close]')
      expect(picturesCloseButton.attr('style')).toEqual('display: none;')

    it 'enterEditMode is hiding the widgets\' forms', ->
      Dashboard.Widgets.Manager.enterEditMode()
      picturesCloseButton = $('[data-id=pictures-close]')
      expect(picturesCloseButton.attr('style')).not.toEqual('display: none;')
