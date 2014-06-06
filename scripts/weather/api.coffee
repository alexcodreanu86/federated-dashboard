namespace('Weather')

class Weather.API
  @getCurrentConditions: (zipcode, callback) ->
    $.get("http://api.wunderground.com/api/12ba191e2fec98ad/conditions/q/#{zipcode}.json", (response) ->
      callback(response.current_observation)
      response
    , "jsonp")
