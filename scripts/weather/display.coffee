namespace('Weather')

class Weather.Display
  @getInput: ->
    $('[name=weather-search]').val()

  @showWeather: (weatherObj) ->
    weatherHTML = Weather.Display.generateHtml(weatherObj)
    $('[data-id=weather-output]').html(weatherHTML)

  @generateHtml: (weatherObj) ->
    new EJS({url: 'scripts/weather/template.ejs'}).render(weatherObj)


