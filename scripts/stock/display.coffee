namespace('Stock')

class Stock.Display
  @getInput: ->
    $('[name=stock-search]').val()

  @outputData: (stockObj) ->
    stockHtml = new EJS({url: 'scripts/stock/tRowTemplate.ejs'}).render(stockObj)
    $('[data-id=stock-body]').append(stockHtml)

  @resetTable: ->
    table = new EJS({url: 'scripts/stock/tableTemplate.ejs'}).render({})
    $('[data-id=stock-output]').html(table)
