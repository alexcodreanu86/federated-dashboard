describe "Weather.Controller", ->
  beforeEach ->
    setupWeatherFixtures()
    Weather.Controller.bind()

  it "the weather is displayed when the button is clicked", ->
    spyOn(Weather.API, 'getCurrentConditions').and.returnValue(Weather.Display.showWeather(weatherObj.current_observation))
    inputInto('weather-search', "60714")
    clickOn('[data-id=weather-button]')
    expect($('[data-id=weather-output]').html()).toContainText('Niles')

  it "getCurrentWeather calls Weather.Wrapper.getCurrentConditions", ->
    spy = spyOn(Weather.Wrapper, 'getCurrentConditions').and.returnValue({})
    Weather.Controller.getCurrentWeather('60714')
    expect(spy).toHaveBeenCalledWith('60714', Weather.Display.showWeather)
