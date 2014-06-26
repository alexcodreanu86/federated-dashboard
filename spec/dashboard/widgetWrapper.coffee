widgetConfig = {
  widget: Pictures,
  apiKey: "some_api_key",
  name: "pictures"
}

wrapper = null

describe "Dashboard.WidgetWrapper", ->
  beforeEach ->
    wrapper = new Dashboard.WidgetWrapper(widgetConfig)

  it "widget returns the widget it is initialized with", ->
    expect(wrapper.widget).toEqual(Pictures)

  it "widgetApiKey returns the api:key that it was initialized with", ->
    expect(wrapper.widgetApiKey).toEqual("some_api_key")

  it "container returns the container it was initialized in", ->
    wrapper.container = "[data-id=widget-container]"
    expect(wrapper.container).toEqual("[data-id=widget-container]")

  it "name returns the name of the widget", ->
    expect(wrapper.name).toEqual("pictures")

  it "setupWidget is setting up the widget in the given container", ->
    spy = spyOn(Pictures.Controller, 'setupWidgetIn')
    wrapper.container = "[data-id=widget-container]"
    wrapper.setupWidget()
    expect(spy).toHaveBeenCalledWith('[data-id=widget-container]', "some_api_key")

  it "isActive is false on initialization", ->
    expect(wrapper.isActive).toBe(false)

  it "isActive can be updated", ->
    wrapper.isActive = true
    expect(wrapper.isActive).toBe(true)

  it "widgetLogo returns the logo of the widget it is initialized with", ->
    picturesLogo = wrapper.widgetLogo()
    expect(picturesLogo).toBeMatchedBy('[data-id=pictures-widget]')

