express = require('express')
fs = require('fs')
path = require('path')
util = require('util')
Twitter = require('./bower_components/twitter-widget/dist/backend_module')

request = require('request')
url = require('url')
FeedParser = require('feedparser')

app = express()

twit = Twitter.setupAuthenticationObject()
app.use(express.static(__dirname))
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'ejs')

app.get '/search_twitter/:search_for', (request, response) ->
  searchFor = request.params.search_for
  searchKey = Twitter.getSearchFormat(searchFor)
  twit.search searchKey, {count: 5, result_type: 'recent'}, (data) ->
    data.statuses
    response.send data.statuses

app.post '/blog_feed', (req, res) ->
  urlData = undefined
  req.on('data', (data) ->
    urlData = data
  )
  req.on('end', ->
    url = JSON.parse(urlData).url
    console.log url
    processRequest(url, res)
  )

processRequest = (url, response) ->
  data = []
  feedRequest = request(url)
  feedParser = new FeedParser()
  feedRequest.on('response', (resp) ->
    this.pipe(feedParser)
  )

  feedParser.on('readable', ->
    data.push(item) while item = this.read()
  )

  feedParser.on('error',(err) ->
    console.log 'Not a valid feed'
    console.log err
  )

  feedParser.on('end', ->
    response.send(data)
  )

app.get '/', (request, response) ->
  response.render 'index', {title: "Federated dashboard"}

server = app.listen 5000, ->
  console.log "listening on port #{server.address().port}"
