namespace('Stock')

class Stock.Controller
  @bind: ->
    $('[data-id=stock-button]').click(=> @getStockData(Stock.View.getInput()))

  @getStockData: (searchStr) ->
    Stock.View.resetTable()
    _.each(@processInput(searchStr), (symbol) ->
      Stock.API.loadData(symbol, Stock.View.outputData)
    )

  @processInput: (string) ->
    string.split(/\s+/)

  @setupWidgetIn: (selector) ->
    Stock.View.displayFormIn(selector)
    @bind()

