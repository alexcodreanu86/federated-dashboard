setupFixtures = ->
  setFixtures """
                <input name='twitter-search'>
                <button data-id='twitter-button'></button>
                <div data-id='twitter-output'></div>
              """
setInputValue = (value) ->
  $('[name=twitter-search]').val(value)

clickButton = ->
  $('[data-id=twitter-button]').click()

twitterResponse = [
  {
    text: "Some Text"
  },
  {
    text: "Other text"
  },
  {
    text: "Third text"
  }
]
getJsonObject = ->
  JSON.stringify(twitterResponse)

setupTwitterDisplay = ->
  setupFixtures()
  Twitter.Controller.bind()
  setInputValue('bikes')

describe "Twitter.Controller", ->
  it "bind displays tweets with the search input when twitter button is clicked", ->
    setupTwitterDisplay()
    server = sinon.fakeServer.create()
    server.respondWith(/.+/, getJsonObject())
    clickButton()
    server.respond()
    expect($('[data-id=twitter-output]')).toContainText("Some Text")
    expect($('[data-id=twitter-output]')).toContainText("Other text")
    expect($('[data-id=twitter-output]')).toContainText("Third text")
    server.restore()

  it "generateUrl returns a url with the string included in the string", ->
    url = Twitter.Controller.generateUrl('bikes')
    expect(url).toEqual('/search_twitter/bikes')
