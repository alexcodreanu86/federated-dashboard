setupStockFixtures = ->
  setFixtures """
                <input name="stock-search" type="text">
                <button data-id="stock-button"></button>
                <div data-id="stock-output"></div>
              """

stockObj = {Name: "Apple Inc", Symbol: "AAPL", Change: 2.46999999999991, ChangePercent: 0.383052634843819, ChangePercentYTD: 15.3773484011265, Open: 646.3, ChangeYTD: 561.02, High: 649.35, LastPrice: 647.29, Low: 642.72, MSDate: 41795.6659722222, MarketCap: 557563307490, Open: 646.3, Timestamp: "Thu Jun 5 15:59:00 UTC-04:00 2014", Volume: 972798 }

inputInto = (name, value)->
  $("[name=#{name}]").val(value)

clickOn = (element) ->
  $(element).click()

describe "Stock.Controller", ->

  it 'bind calls getStockData wth the current text in the input', ->
    setupStockFixtures()
    Stock.Controller.bind()
    spyOn(Stock.Controller, 'getStockData')
    inputInto('stock-search', 'AAPL')
    clickOn('[data-id=stock-button]')
    expect(Stock.Controller.getStockData).toHaveBeenCalledWith('AAPL')

  it "getStockData calls the stockApi 3 times for a string that contains 3 symbols", ->
    spy = spyOn(Stock.API, 'loadData')
    Stock.Controller.getStockData('AAPL GOOG MSFT')
    expect(spy.calls.count()).toEqual(3)

  it "getStockData resets the stock table", ->
    tableSpy = spyOn(Stock.View, 'resetTable')
    spyOn(Stock.API, 'loadData')
    Stock.Controller.getStockData('AAPL')
    expect(tableSpy).toHaveBeenCalled()

  it "processInput returns an array of words in a string", ->
    expect(Stock.Controller.processInput('some string here')).toEqual(['some', 'string', 'here'])

  it 'bind displays stock data for each symbol in the search-field', ->
    setupStockFixtures()
    Stock.Controller.bind()
    inputInto('stock-search', 'AAPL GOOG MSFT')
    spyOn(Stock.API,'loadData').and.returnValue(Stock.View.outputData(stockObj))
    clickOn('[data-id=stock-button]')
    expect(Stock.API.loadData.calls.count()).toEqual(3)

  it 'setupFormIn appends form to the given selector', ->
    setFixtures(sandbox())
    Stock.Controller.setupWidgetIn('#sandbox')
    expect($('#sandbox')).toContainElement('[data-id=stock-button]')
