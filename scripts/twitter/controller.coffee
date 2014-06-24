namespace('Twitter')

class Twitter.Controller
  @bind: ->
    $('[data-id=twitter-button]').click( => @getTweeterPosts(Twitter.View.getInput()))

  @getTweeterPosts: (searchInput) ->
    url = @generateUrl(searchInput) 
    $.get(url, (response) ->
      Twitter.View.displayTweets(response)
    , 'json')

  @generateUrl: (input) ->
    "/search_twitter/#{input}"

