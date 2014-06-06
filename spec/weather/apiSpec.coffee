describe 'Weather.API', ->
  it "getCurrentConditions returns current conditions for the argument zipcode", ->
    spyOn($, 'get').and.returnValue(weatherObj)
    response = Weather.API.getCurrentConditions('60714')
    expect(response).toEqual(weatherObj)
