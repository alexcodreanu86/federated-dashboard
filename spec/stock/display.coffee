setupStockFixtures = ->
  setFixtures """
                <div id="stock-wrapper">
                  <input name="stock-search" type="text"><br>
                  <button data-id="stock-button">Get Stock Data</button><br>
                <div data-id="stock-output"></div>
              """
window.setupStockFixtures = setupStockFixtures

describe 'Stock.Display', ->
  beforeEach ->
    setupStockFixtures() 

  it "getInput returns the text from the input field" , ->
    inputInto('stock-search', 'AAPL')
    expect(Stock.Display.getInput()).toEqual('AAPL')

  it "resetTable adds an empty table to the page", ->
    Stock.Display.resetTable()
    expect($('[data-id=stock-output]').html()).toContainElement('thead')
    expect($('[data-id=stock-output]').html()).not.toContainElement('td')

  it 'outputData adds a row with the stock Object information to the table body', ->
    Stock.Display.resetTable()
    Stock.Display.outputData(stockObj)
    expect($('[data-id=stock-body]').html()).toContainText('Apple Inc')
