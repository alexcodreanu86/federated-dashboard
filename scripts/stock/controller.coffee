namespace('Stock')

class Stock.Controller
  @bind: ->
    $('[data-id=stock-button]').click(=> @getStockData(Stock.Display.getInput()))

  @getStockData: (searchStr) ->
    Stock.Display.resetTable()
    _.each(@processInput(searchStr), (symbol) ->
      Stock.API.loadData(symbol, Stock.Display.outputData)
    )

  @processInput: (string) ->
    string.split(/\s+/)

