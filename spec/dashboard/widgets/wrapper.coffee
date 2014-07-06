widgetConfig = {
  widget: Pictures,
  apiKey: "some_api_key",
  name: "pictures"
  numberOfSlots: 2
}

wrapper = null

setWrapperInContainer = ->
  setFixtures(sandbox())
  $('#sandbox').append("<div data-id='widget-container'></div>")
  wrapper.setupWidgetIn(containerInfo)

containerInfo = {
  containerName: "[data-id=widget-container]",
  containerColumn: "col0"
}

describe "Dashboard.Widgets.Wrapper", ->
  beforeEach ->
    wrapper = new Dashboard.Widgets.Wrapper(widgetConfig)

  it "widget returns the widget it is initialized with", ->
    expect(wrapper.widget).toEqual(Pictures)

  it "widgetApiKey returns the api:key that it was initialized with", ->
    expect(wrapper.widgetApiKey).toEqual("some_api_key")

  it "name returns the name of the widget", ->
    expect(wrapper.name).toEqual("pictures")

  it "setupWidget is storing the container it receives", ->
    wrapper.setupWidgetIn(containerInfo)
    expect(wrapper.containerName).toEqual("[data-id=widget-container]")

  it "setupWidget is updating isActive status", ->
    wrapper.setupWidgetIn(containerInfo)
    expect(wrapper.isActive).toBe(true)

  it "setupWidget is storing the column the widget is displayed in", ->
    wrapper.setupWidgetIn(containerInfo)
    expect(wrapper.containerColumn).toEqual("col0")

  it "setupWidget is setting up the widget in the given container", ->
    spy = spyOn(Pictures.Controller, 'setupWidgetIn')
    wrapper.setupWidgetIn(containerInfo)
    expect(spy).toHaveBeenCalledWith('[data-id=widget-container]', "some_api_key")

  it "isActive is false on initialization", ->
    expect(wrapper.isActive).toBe(false)

  it "isActive can be updated", ->
    wrapper.isActive = true
    expect(wrapper.isActive).toBe(true)

  it "widgetLogo returns the logo of the widget it is initialized with", ->
    picturesLogo = wrapper.widgetLogo()
    expect(picturesLogo.html).toBeMatchedBy('[data-id=pictures-widget]')

  it "deactivateWidget is removing the widget off the screen", ->
    setWrapperInContainer()
    expect($("[data-id=widget-container]")).toContainElement("[data-id=pictures-button]")
    wrapper.deactivateWidget()
    expect($('#sandbox')).not.toContainElement('[data-id=widget-container]')

  it "deactivateWidget is removing the widget off the screen", ->
    setWrapperInContainer()
    expect(wrapper.isActive).toBe(true)
    wrapper.deactivateWidget()
    expect(wrapper.isActive).toBe(false)
