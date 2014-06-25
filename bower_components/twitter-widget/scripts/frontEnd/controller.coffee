namespace('Twitter')

class Twitter.Controller
  @bind: ->
    $('[data-id=twitter-button]').click( => @getTweeterPosts(Twitter.Display.getInput()))

  @getTweeterPosts: (searchInput) ->
    url = @generateUrl(searchInput) 
    $.get(url, (response) ->
      Twitter.Display.showTweets(response)
    , 'json')

  @generateUrl: (input) ->
    "/search_twitter/#{input}"

  @setupWidgetIn: (element) ->
    Twitter.Display.showFormIn(element)
    @bind()

  @iconUrl = "https://d30y9cdsu7xlg0.cloudfront.net/svg/f7bab68f-2ac2-493e-95f9-3e73356dcf43.svg?Expires=1403711665&amp;Signature=A4Di1ydRnSwxz75IFrSbz36lWvpMCoDZv6kXwkI5PzYPKldyKXva6ej5a80n2f2AHRM6HNM9EAq5OP9CbZeqhsjSonYXfI-uTn68SDW26uv5tgMFwFhSSRdSHlmKHfH6z4XaAaoI9OMEUaVZnI2ATZDqWv2Q~Wszhd5bqmIf8Us_&amp;Key-Pair-Id=APKAI5ZVHAXN65CHVU2Q"
