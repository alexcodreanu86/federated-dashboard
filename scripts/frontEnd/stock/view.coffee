namespace('Stock')

class Stock.View
  @getInput: ->
    $('[name=stock-search]').val()

  @outputData: (stockObj) ->
    formatedObj = Stock.View.formatResponse(stockObj)
    stockHtml = new EJS({url: 'scripts/frontEnd/stock/tRowTemplate.ejs'}).render(formatedObj)
    $('[data-id=stock-body]').append(stockHtml)

  @resetTable: ->
    table = new EJS({url: 'scripts/frontEnd/stock/tableTemplate.ejs'}).render({})
    $('[data-id=stock-output]').html(table)

  @formatResponse: (response) ->
    { name: response.Name, symbol: response.Symbol, change: response.Change.toFixed(2), changePercent: response.ChangePercent.toFixed(2), changePercentYTD: response.ChangePercentYTD.toFixed(2), open: response.Open.toFixed(2), changeYTD: response.ChangeYTD.toFixed(2), high: response.High, lastPrice: response.LastPrice, low: response.Low, msDate: response.MSDate.toFixed(2), marketCap: response.MarketCap, open: response.Open, timestamp: response.Timestamp.substr(0, 18), volume: response.Volume }
