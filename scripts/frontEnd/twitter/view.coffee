namespace('Twitter')

class Twitter.View
  @getInput: ->
    $('[name=twitter-search]').val()

  @generateHtml: (twitterResponse) ->
    new EJS({url: 'scripts/frontEnd/twitter/template.ejs'}).render(statuses: twitterResponse)

  @displayTweets: (twitterResponse) ->
    twitterHtml = @generateHtml(twitterResponse)
    $('[data-id=twitter-output]').html(twitterHtml)
