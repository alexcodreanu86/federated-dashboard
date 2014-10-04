describe "Dashboard.Widgets.Wrapper", ->
  wrapper = null

  setWrapperInContainer = ->
    setFixtures(sandbox())
    $('#sandbox').append("<div data-id='widget-container'></div>")
    wrapper.setupWidgetIn(containerName)

  containerName = "[data-id=widget-container]"

  widgetConfig = (slotSize) ->
    {
      widget: Pictures,
      apiKey: "some_api_key",
      name: "pictures",
      slotSize: slotSize
    }

  beforeEach ->
    wrapper = new Dashboard.Widgets.Wrapper(widgetConfig('s'))

  it "widget returns the widget it is initialized with", ->
    expect(wrapper.widget).toEqual(Pictures)

  it "name returns the name of the widget", ->
    expect(wrapper.name).toEqual("pictures")

  it "setupWidget is setting up the widget in the given container", ->
    setWrapperInContainer()
    expect($(containerName)).not.toBeEmpty()

  it "widgetLogo returns the logo of the widget it is initialized with", ->
    picturesLogo = wrapper.widgetLogo()
    expect(picturesLogo).toBeMatchedBy('[data-id=pictures-widget]')

  it "assigns slotSize on initialization", ->
    expect(wrapper.slotSize).toBe(1)

  it "getSlotSize returns 1 for s or S", ->
    expect(wrapper.getSlotSize("s")).toBe(1)
    expect(wrapper.getSlotSize('S')).toBe(1)

  it "getSlotSize returns 2 for m or M", ->
    expect(wrapper.getSlotSize("m")).toBe(2)
    expect(wrapper.getSlotSize('M')).toBe(2)

  it "getSlotSize returns 3 anything else", ->
    expect(wrapper.getSlotSize("L")).toBe(3)
    expect(wrapper.getSlotSize('XL')).toBe(3)
