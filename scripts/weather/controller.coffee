namespace('Weather')

class Weather.Controller
  @bind: ->
    $('[data-id=weather-button]').click( => @getCurrentWeather(Weather.Display.getInput()))

  @getCurrentWeather: (zipcode) ->
    Weather.Wrapper.getCurrentConditions(zipcode, Weather.Display.showWeather)

