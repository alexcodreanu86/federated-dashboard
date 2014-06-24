setInputValue = (value)  ->
  $("[name=twitter-search]").val(value)

twitterResponse = [
  {
    "text": "Some Text"
  },
  {
    "text": "Other text"
  },
  {
    "text": "Third text"
  }
]

describe "Twitter.View", ->
  it "getInput returns the text in the search box", ->
    setFixtures("<input name='twitter-search'>")
    setInputValue("bikes")
    expect(Twitter.View.getInput()).toEqual("bikes")

  it "displayTweets is displaying the tweets", ->
    setFixtures('<div data-id="twitter-output"></div>')
    Twitter.View.displayTweets(twitterResponse)
    expect($('[data-id=twitter-output]')).toContainText("Some Text")
    expect($('[data-id=twitter-output]')).toContainText("Other text")
    expect($('[data-id=twitter-output]')).toContainText("Third text")

