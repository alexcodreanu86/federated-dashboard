namespace('Stock')

class Stock.API

  @loadData: (symbol, callback) ->
    $.ajax({
      method: 'GET',
      url: 'http://dev.markitondemand.com/Api/v2/Quote/jsonp',
      data: {symbol: symbol},
      dataType: 'jsonp',
      success: callback,
      error: console.log
    })
