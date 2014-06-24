Twitter = require('../../scripts/twitter/backend_module/api.coffee')

describe 'Twitter', ->
  it "setupAuthenticationObject returns a twitter object", ->
    expect(Twitter.setupAuthenticationObject()).toBeDefined()

  it "getSearchFormat generates a query string", ->
    searchParam = "bikes"
    generatedString = Twitter.getSearchFormat(searchParam)
    expect(generatedString).toEqual('bikes OR #bikes')
