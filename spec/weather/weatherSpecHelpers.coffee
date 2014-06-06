weatherObj = {  current_observation: {
                  display_location: {
                    full: "Niles IL"
                  }, weather: "Partly Cloudy", temp_f: "77.9", icon_url: "http://icons.wxug.com/i/c/k/partlycloudy.gif"
                }
              }
setupWeatherFixtures = ->
  setFixtures """
                <div id="weather-wrapper">
                  <input name="weather-search" type="text"><br>
                  <button data-id="weather-button">Get current weather</button><br>
                <div data-id="weather-output"></div>
              """

window.weatherObj = weatherObj
window.setupWeatherFixtures = setupWeatherFixtures
