express = require('express')
fs = require('fs')
path = require('path')
util = require('util')
Twitter = require('./dist/backend_module')
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

app.get '/', (request, response) ->
  response.render 'index', {title: "Twitter Widget"}

server = app.listen 5000, ->
  console.log "listening on port #{server.address().port}"
