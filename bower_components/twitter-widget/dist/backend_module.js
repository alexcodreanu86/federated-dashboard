(function() {
  var Twitter, twitter;

  twitter = require('twitter');

  Twitter = (function() {
    function Twitter() {}

    Twitter.setupAuthenticationObject = function() {
      return new twitter({
        consumer_key: process.env.TWITTER_API_KEY,
        consumer_secret: process.env.TWITTER_API_SECRET,
        access_token_key: process.env.TWITTER_ACCESS_TOKEN,
        access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET
      });
    };

    Twitter.getSearchFormat = function(searchString) {
      return "" + searchString + " OR #" + searchString;
    };

    return Twitter;

  })();

  module.exports = Twitter;

}).call(this);
