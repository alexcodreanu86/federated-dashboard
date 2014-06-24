stockObj = {Name: "Apple Inc", Symbol: "AAPL", Change: 2.46999999999991, ChangePercent: 0.383052634843819, ChangePercentYTD: 15.3773484011265, Open: 646.3, ChangeYTD: 561.02, High: 649.35, LastPrice: 647.29, Low: 642.72, MSDate: 41795.6659722222, MarketCap: 557563307490, Open: 646.3, Timestamp: "Thu Jun 5 15:59:00 UTC-04:00 2014", Volume: 972798 }

appendToSandbox = (htmlToAppend) ->
  $('#sandbox').html(htmlToAppend)

setSandbox = ->
  setFixtures(sandbox())

describe "Stock.Templates", ->
  it "renderForm returns the proper html", ->
    formHtml = Stock.Templates.renderForm()
    setSandbox()
    appendToSandbox(formHtml)
    expect($('[name=stock-search]')).toBeInDOM()
    expect($('[data-id=stock-button]')).toBeInDOM()
    expect($('[data-id=stock-output]')).toBeInDOM()

  it "renderEmptyTable returns the proper html", ->
    tableHtml = Stock.Templates.renderEmptyTable()
    setSandbox()
    appendToSandbox(tableHtml)
    expect($('[data-id=stock-display]')).toBeInDOM()

  it "renderTableRow returns the proper html", ->
    formatedResponse = Stock.View.formatResponse(stockObj)
    tRowHtml = Stock.Templates.renderTableRow(formatedResponse)
    setSandbox()
    appendToSandbox(tRowHtml)
    expect($('#sandbox')).toContainElement("tr")
    expect($('td').first()).toContainText('Apple Inc')
