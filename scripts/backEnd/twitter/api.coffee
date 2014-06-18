twitter = require('twitter')

class Twitter
  @setupAuthenticationObject: ->
    new twitter
      consumer_key: process.env.TWITTER_API_KEY,
      consumer_secret: process.env.TWITTER_API_SECRET,
      access_token_key: process.env.TWITTER_ACCESS_TOKEN,
      access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET

  @getSearchFormat: (searchString) ->
    "#{searchString} OR ##{searchString}"

module.exports = Twitter
