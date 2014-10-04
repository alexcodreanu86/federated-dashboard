(function() {
  var FeedParser, Twitter, app, express, fs, gmailRouter, path, processRequest, request, server, twit, url, util;

  express = require('express');

  fs = require('fs');

  path = require('path');

  util = require('util');

  Twitter = require('./bower_components/twitter-widget/dist/backend_module');

  gmailRouter = require('./bower_components/notification-widget/dist/backEnd/router');

  request = require('request');

  url = require('url');

  FeedParser = require('feedparser');

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

  app.post('/blog_feed', function(req, res) {
    var urlData;
    urlData = void 0;
    req.on('data', function(data) {
      return urlData = data;
    });
    return req.on('end', function() {
      url = JSON.parse(urlData).url;
      console.log(url);
      return processRequest(url, res);
    });
  });

  processRequest = function(url, response) {
    var data, feedParser, feedRequest;
    data = [];
    feedRequest = request(url);
    feedParser = new FeedParser();
    feedRequest.on('response', function(resp) {
      return this.pipe(feedParser);
    });
    feedParser.on('readable', function() {
      var item, _results;
      _results = [];
      while (item = this.read()) {
        _results.push(data.push(item));
      }
      return _results;
    });
    feedParser.on('error', function(err) {
      console.log('Not a valid feed');
      return console.log(err);
    });
    return feedParser.on('end', function() {
      return response.send(data);
    });
  };

  app.get('/', gmailRouter.getPermission);

  app.get('/emails', gmailRouter.getEmails);

  app.get('/emails/:id', gmailRouter.getEmail);

  app.get('/google_response', function(request, response) {
    gmailRouter.googleRedirect(request, response);
    return response.redirect('/dashboard');
  });

  app.get('/dashboard', function(request, response) {
    return response.render('index', {
      title: "Federated dashboard"
    });
  });

  server = app.listen(5000, function() {
    return console.log("listening on port " + (server.address().port));
  });

}).call(this);
