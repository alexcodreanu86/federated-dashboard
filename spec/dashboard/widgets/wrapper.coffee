widgetConfig = {
  widget: Pictures,
  apiKey: "some_api_key",
  name: "pictures",
  slotSize: 2
}

wrapper = null

setWrapperInContainer = ->
  setFixtures(sandbox())
  $('#sandbox').append("<div data-id='widget-container'></div>")
  wrapper.setupWidgetIn(containerName)

containerName = "[data-id=widget-container]"

describe "Dashboard.Widgets.Wrapper", ->
  beforeEach ->
    wrapper = new Dashboard.Widgets.Wrapper(widgetConfig)

  it "widget returns the widget it is initialized with", ->
    expect(wrapper.widget).toEqual(Pictures)

  it "widgetApiKey returns the api key that it was initialized with", ->
    expect(wrapper.widgetApiKey).toEqual("some_api_key")

  it "name returns the name of the widget", ->
    expect(wrapper.name).toEqual("pictures")

  it "setupWidget is storing the container it receives", ->
    wrapper.setupWidgetIn(containerName)
    expect(wrapper.container).toEqual("[data-id=widget-container]")

  it "setupWidget is setting up the widget in the given container", ->
    spy = spyOn(Pictures.Controller, 'setupWidgetIn')
    wrapper.setupWidgetIn(containerName)
    expect(spy).toHaveBeenCalledWith('[data-id=widget-container]', "some_api_key", undefined)

  it "widgetLogo returns the logo of the widget it is initialized with", ->
    picturesLogo = wrapper.widgetLogo()
    expect(picturesLogo).toBeMatchedBy('[data-id=pictures-widget]')

  it "hideWidgetForm is hiding the widgets form", ->
    setWrapperInContainer()
    wrapper.hideWidgetForm()
    expect($('[data-id=pictures-form]').attr('style')).toEqual('display: none;')

  it "showWidgetForm displays the widget form", ->
    setWrapperInContainer()
    wrapper.hideWidgetForm()
    wrapper.showWidgetForm()
    expect($('[data-id=pictures-form]').attr('style')).not.toEqual('display: none;')
