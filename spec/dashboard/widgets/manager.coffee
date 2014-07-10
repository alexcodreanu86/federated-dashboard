describe "Dashboard.Widgets.Manager", ->
  it "wrapWidget returns a new widgetWrapper", ->
    wrapper = Dashboard.Widgets.Manager.wrapWidget(Pictures, "pictures", 3, "some-api-key")
    expect(wrapper.name).toEqual("pictures")
    expect(wrapper.widgetApiKey).toEqual("some-api-key")
    expect(wrapper.slotSize).toEqual(3)
    expect(wrapper.widget).toEqual(Pictures)

  it "wrappedWidgets has 4 widgets setup", ->
    Dashboard.Widgets.Manager.generateWrappers()
    widgets = _.keys(Dashboard.Widgets.Manager.wrappers)
    expect(widgets.length).toEqual(4)

  it "getActiveWidgets returns an emtpy container when no widgets are active", ->
    Dashboard.Widgets.Manager.generateWrappers()
    activeWidgets = Dashboard.Widgets.Manager.getActiveWidgets()
    expect(activeWidgets).toEqual([])

  it "getActiveWidgets returns all the active widgets", ->
    Dashboard.Widgets.Manager.generateWrappers()
    picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    weatherWrapper  = Dashboard.Widgets.Manager.wrappers.weather
    picturesWrapper.isActive = true
    weatherWrapper.isActive = true
    activeWidgets = Dashboard.Widgets.Manager.getActiveWidgets()
    expect(activeWidgets).toEqual([picturesWrapper, weatherWrapper])

  it "getSidenavButtons returns the buttons for all widgets", ->
    Dashboard.Widgets.Manager.generateWrappers()
    buttons = Dashboard.Widgets.Manager.getSidenavButtons()
    expect(buttons[0].html).toBeMatchedBy('[data-id=pictures-widget]')
    expect(buttons[1].html).toBeMatchedBy('[data-id=weather-widget]')
    expect(buttons[2].html).toBeMatchedBy('[data-id=twitter-widget]')
    expect(buttons[3].html).toBeMatchedBy('[data-id=stock-widget]')

  it "getActiveWidgetsData returns an empty container when no widget is active", ->
    data = Dashboard.Widgets.Manager.getActiveWidgetsData()
    expect(data).toEqual([])

  it "getContainerAndNameOf returns the name and the container of the given widget", ->
    picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    picturesWrapper.isActive = true
    picturesWrapper.containerName = "pictures-container"
    data = Dashboard.Widgets.Manager.getContainerAndNameOf(picturesWrapper)
    expect(data.container).toEqual("pictures-container")
    expect(data.name).toEqual("pictures")


  it "getActiveWidgetsData returns the container name and the widget name for for all the active widgets", ->
    Dashboard.Widgets.Manager.generateWrappers()
    picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    weatherWrapper  = Dashboard.Widgets.Manager.wrappers.weather
    picturesWrapper.isActive = true
    picturesWrapper.containerName = "pictures-container"
    weatherWrapper.isActive = true
    weatherWrapper.containerName = "weather-container"
    expectedResponse = [{container: "pictures-container", name: "pictures"}, {container: "weather-container", name: "weather"}]
    activeWidgetsInfo = Dashboard.Widgets.Manager.getActiveWidgetsData()
    expect(activeWidgetsInfo).toEqual(expectedResponse)

  it "hideActiveForms is hiding the forms of active widgets", ->
    Dashboard.Widgets.Manager.generateWrappers()
    picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    weatherWrapper  = Dashboard.Widgets.Manager.wrappers.weather
    picturesWrapper.isActive = true
    weatherWrapper.isActive = true
    picturesSpy = spyOn(Pictures.Display, 'hideForm')
    weatherSpy = spyOn(Weather.Display, 'hideForm')
    twitterSpy = spyOn(Twitter.Display, 'hideForm')
    stockSpy = spyOn(Stock.Display, 'hideForm')
    Dashboard.Widgets.Manager.hideActiveForms()
    expect(picturesSpy).toHaveBeenCalled()
    expect(weatherSpy).toHaveBeenCalled()
    expect(twitterSpy).not.toHaveBeenCalled()
    expect(stockSpy).not.toHaveBeenCalled()

  it "showActiveForms is showing the forms of active widgets", ->
    Dashboard.Widgets.Manager.generateWrappers()
    picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    weatherWrapper  = Dashboard.Widgets.Manager.wrappers.weather
    picturesWrapper.isActive = true
    weatherWrapper.isActive = true
    picturesSpy = spyOn(Pictures.Display, 'showForm')
    weatherSpy = spyOn(Weather.Display, 'showForm')
    twitterSpy = spyOn(Twitter.Display, 'showForm')
    stockSpy = spyOn(Stock.Display, 'showForm')
    Dashboard.Widgets.Manager.showActiveForms()
    expect(picturesSpy).toHaveBeenCalled()
    expect(weatherSpy).toHaveBeenCalled()
    expect(twitterSpy).not.toHaveBeenCalled()
    expect(stockSpy).not.toHaveBeenCalled()

  it "getWrapperWithContainer returns the wrapper that has the given contaienr", ->
    Dashboard.Widgets.Manager.generateWrappers()
    picturesWrapper = Dashboard.Widgets.Manager.wrappers.pictures
    picturesWrapper.containerName = "[data-id=pictures-slot]"
    returnedWrapper = Dashboard.Widgets.Manager.getWrapperInContainer("[data-id=pictures-slot]")
    expect(returnedWrapper).toEqual(picturesWrapper)
