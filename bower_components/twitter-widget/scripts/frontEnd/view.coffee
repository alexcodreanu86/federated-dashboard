namespace('Twitter')

class Twitter.Display
  @getInput: ->
    $('[name=twitter-search]').val()

  @generateHtml: (twitterResponse) ->
    Twitter.Templates.renderTweets(twitterResponse)

  @showTweets: (twitterResponse) ->
    twitterHtml = @generateHtml(twitterResponse)
    $('[data-id=twitter-output]').html(twitterHtml)

  @showFormIn: (container) ->
    formHtml = Twitter.Templates.renderForm()
    $(container).html(formHtml)

  @logoSrc = "https://raw.githubusercontent.com/bwvoss/federated-dashboard-twitter-widget/master/lib/icon_25838/icon_25838.png"

  @generateLogo: (config) ->
    logoSrc = @logoSrc
    _.extend(config, {imgSrc: logoSrc})
    Twitter.Templates.renderImage(config)
