describe "Weather.Display", ->
  beforeEach ->
    setupWeatherFixtures()

  it "getInput returns the input in the weather-search field", ->
    inputInto('weather-search', '60714')
    expect(null).toBe(null)
    expect(Weather.Display.getInput()).toEqual('60714')

  it "showWeather displays the current Weather", ->
    Weather.Display.showWeather(weatherObj.current_observation)
    html = $("[data-id=weather-output]")
    expect(html).toContainHtml("<p>Niles IL 77.9° F</p>")

  it "generateHtml generates proper html string", ->
    str = Weather.Display.generateHtml(weatherObj.current_observation)
    expect(str).toContainElement('img')
    expect(str).toContainText('Niles')
