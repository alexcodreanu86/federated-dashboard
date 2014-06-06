stockObj = {Name: "Apple Inc", Symbol: "AAPL", Change: 2.46999999999991, ChangePercent: 0.383052634843819, ChangePercentYTD: 15.3773484011265, Open: 646.3, ChangeYTD: 561.02, High: 649.35, LastPrice: 647.29, Low: 642.72, MSDate: 41795.6659722222, MarketCap: 557563307490, Open: 646.3, Timestamp: "Thu Jun 5 15:59:00 UTC-04:00 2014", Volume: 972798 }

window.stockObj = stockObj

describe 'Stock.API', ->
  it "calls the callback with a stock Object", ->
    display = jasmine.createSpy('display')
    #spyOn($, 'ajax').and.returnValue(stockObj)
    Stock.API.loadData("AAPL", display)
    expect($.ajax).toHaveBeenCalled()
