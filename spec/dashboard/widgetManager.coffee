describe "Dashboard.WidgetManager", ->
  it "wrapWidget returns a new widgetWrapper", ->
    wrapper = Dashboard.WidgetManager.wrapWidget(Pictures, "pictures", 3, "some-api-key")
    expect(wrapper.name).toEqual("pictures")
    expect(wrapper.widgetApiKey).toEqual("some-api-key")
    expect(wrapper.numberOfSlots).toEqual(3)
    expect(wrapper.widget).toEqual(Pictures)

  it "wrappedWidgets has 4 widgets setup", ->
    Dashboard.WidgetManager.generateWrappers()
    widgets = _.keys(Dashboard.WidgetManager.wrappers)
    expect(widgets.length).toEqual(4)

  it "getActiveWidgets returns an emtpy container when no widgets are active", ->
    Dashboard.WidgetManager.generateWrappers()
    activeWidgets = Dashboard.WidgetManager.getActiveWidgets()
    expect(activeWidgets).toEqual([])

  it "getActiveWidgets returns all the active widgets", ->
    Dashboard.WidgetManager.generateWrappers()
    picturesWrapper = Dashboard.WidgetManager.wrappers.pictures
    weatherWrapper  = Dashboard.WidgetManager.wrappers.weather
    picturesWrapper.isActive = true
    weatherWrapper.isActive = true
    activeWidgets = Dashboard.WidgetManager.getActiveWidgets()
    expect(activeWidgets).toEqual([picturesWrapper, weatherWrapper])

  it "getSidenavButtons returns the buttons for all widgets", ->
    Dashboard.WidgetManager.generateWrappers()
    buttons = Dashboard.WidgetManager.getSidenavButtons()
    expect(buttons[0].html).toBeMatchedBy('[data-id=pictures-widget]')
    expect(buttons[1].html).toBeMatchedBy('[data-id=weather-widget]')
    expect(buttons[2].html).toBeMatchedBy('[data-id=twitter-widget]')
    expect(buttons[3].html).toBeMatchedBy('[data-id=stock-widget]')

  it "getActiveWidgetsData returns an empty container when no widget is active", ->
    data = Dashboard.WidgetManager.getActiveWidgetsData()
    expect(data).toEqual([])

  it "getContainerAndNameOf returns the name and the container of the given widget", ->
    picturesWrapper = Dashboard.WidgetManager.wrappers.pictures
    picturesWrapper.isActive = true
    picturesWrapper.containerName = "pictures-container"
    data = Dashboard.WidgetManager.getContainerAndNameOf(picturesWrapper)
    expect(data.container).toEqual("pictures-container")
    expect(data.name).toEqual("pictures")


  it "getActiveWidgetsData returns the container name and the widget name for for all the active widgets", ->
    Dashboard.WidgetManager.generateWrappers()
    picturesWrapper = Dashboard.WidgetManager.wrappers.pictures
    weatherWrapper  = Dashboard.WidgetManager.wrappers.weather
    picturesWrapper.isActive = true
    picturesWrapper.containerName = "pictures-container"
    weatherWrapper.isActive = true
    weatherWrapper.containerName = "weather-container"
    expectedResponse = [{container: "pictures-container", name: "pictures"}, {container: "weather-container", name: "weather"}]
    activeWidgetsInfo = Dashboard.WidgetManager.getActiveWidgetsData()
    expect(activeWidgetsInfo).toEqual(expectedResponse)
