widgetConfig = {
  widget: Pictures,
  apiKey: "some_api_key",
  name: "pictures"
  numberOfSlots: 2
}

wrapper = null

setWrapperInContainer = ->
  setFixtures(sandbox())
  $('#sandbox').append("<div id='pictures-container'></div>")
  wrapper.setupWidgetIn(["#pictures-container", "col0"])


describe "Dashboard.WidgetWrapper", ->
  beforeEach ->
    wrapper = new Dashboard.WidgetWrapper(widgetConfig)

  it "widget returns the widget it is initialized with", ->
    expect(wrapper.widget).toEqual(Pictures)

  it "widgetApiKey returns the api:key that it was initialized with", ->
    expect(wrapper.widgetApiKey).toEqual("some_api_key")

  it "name returns the name of the widget", ->
    expect(wrapper.name).toEqual("pictures")

  it "setupWidget is storing the container it receives", ->
    wrapper.setupWidgetIn(["[data-id=widget-container]", "col0"])
    expect(wrapper.containerName).toEqual("[data-id=widget-container]")

  it "setupWidget is updating isActive status", ->
    wrapper.setupWidgetIn(["[data-id=widget-container]", "col0"])
    expect(wrapper.isActive).toBe(true)
  
  it "setupWidget is storing the column the widget is displayed in", ->
    wrapper.setupWidgetIn(["[data-id=widget-container]", "col0"])
    expect(wrapper.containerColumn).toEqual("col0")

  it "setupWidget is setting up the widget in the given container", ->
    spy = spyOn(Pictures.Controller, 'setupWidgetIn')
    wrapper.setupWidgetIn(["[data-id=widget-container]", "col0"])
    expect(spy).toHaveBeenCalledWith('[data-id=widget-container]', "some_api_key")

  it "isActive is false on initialization", ->
    expect(wrapper.isActive).toBe(false)

  it "isActive can be updated", ->
    wrapper.isActive = true
    expect(wrapper.isActive).toBe(true)

  it "widgetLogo returns the logo of the widget it is initialized with", ->
    picturesLogo = wrapper.widgetLogo()
    expect(picturesLogo).toBeMatchedBy('[data-id=pictures-widget]')

  it "closeWidget is removing the widget off the screen", ->
    setWrapperInContainer()
    expect($("#pictures-container")).toContainElement("[data-id=pictures-button]")
    wrapper.closeWidget()
    expect($('#sandbox')).not.toContainElement('#pictures-container')

  it "closeWidget is removing the widget off the screen", ->
    setWrapperInContainer()
    expect(wrapper.isActive).toBe(true)
    wrapper.closeWidget()
    expect(wrapper.isActive).toBe(false)
