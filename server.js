var express = require('express'),
    app = express(),
    fs = require('fs'),
    path = require('path'),
    util = require('util'),
    twitter = require('twitter');

var twit = new twitter({
   consumer_key: process.env.TWITTER_API_KEY,
   consumer_secret: process.env.TWITTER_API_SECRET,
   access_token_key: process.env.TWITTER_ACCESS_TOKEN,
   access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET
})

app.use(express.static(__dirname));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.get('/', function(request, response){
  twit.search('8thLight OR #8thLight',{count: 5}, function(data){
    console.log(data);
  })
  response.render('index', {title: 'hello mister'});
});

app.get('/', function(request, response) {
  response.send('Hello Stranger!');
})

app.get('/:name', function(request, response){
  response.send('Hello ' + request.params.name);
})

var server = app.listen(8000, function(){
  console.log('Listening on port %d', server.address().port);
  console.log(server.address());
})
