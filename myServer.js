(function() {
  var Twitter, app, express, fs, path, server, twit, util;

  express = require('express');

  fs = require('fs');

  path = require('path');

  util = require('util');

  Twitter = require('./.tmp/scripts/backEnd/twitter/api');

  app = express();

  twit = Twitter.setupAuthenticationObject();

  app.use(express["static"](__dirname));

  app.set('views', path.join(__dirname, 'views'));

  app.set('view engine', 'ejs');

  app.get('/search_twitter/:search_for', function(request, response) {
    var searchFor, searchKey;
    searchFor = request.params.search_for;
    searchKey = Twitter.getSearchFormat(searchFor);
    return twit.search(searchKey, {
      count: 5,
      result_type: 'recent'
    }, function(data) {
      data.statuses;
      return response.send(data.statuses);
    });
  });

  app.get('/', function(request, response) {
    return response.render('index', {
      title: "Federated dashboard"
    });
  });

  server = app.listen(5000, function() {
    return console.log("listening on port " + (server.address().port));
  });

}).call(this);

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
