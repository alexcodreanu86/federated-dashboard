describe "Stock.Controller", ->

  beforeEach ->
    setupStockFixtures()
    Stock.Controller.bind()

  it 'bind calls getStockData wth the current text in the input', ->
    spyOn(Stock.Controller, 'getStockData')
    inputInto('stock-search', 'AAPL')
    clickOn('[data-id=stock-button]')
    expect(Stock.Controller.getStockData).toHaveBeenCalledWith('AAPL')

  it "getStockData calls the stockApi 3 times for a string that contains 3 symbols", ->
    spy = spyOn(Stock.API, 'loadData')
    Stock.Controller.getStockData('AAPL GOOG MSFT')
    expect(spy.calls.count()).toEqual(3)

  it "getStockData resets the stock table", ->
    tableSpy = spyOn(Stock.Display, 'resetTable')
    spyOn(Stock.API, 'loadData')
    Stock.Controller.getStockData('AAPL')
    expect(tableSpy).toHaveBeenCalled()

  it "processInput returns an array of words in a string", ->
    expect(Stock.Controller.processInput('some string here')).toEqual(['some', 'string', 'here'])

  it 'bind displays stock data for each symbol in the search-field', ->
    inputInto('stock-search', 'AAPL GOOG MSFT')
    spyOn(Stock.API,'loadData').and.returnValue(Stock.Display.outputData(stockObj))
    clickOn('[data-id=stock-button]')
    expect(Stock.API.loadData.calls.count()).toEqual(3)
