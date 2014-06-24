namespace('Stock')

class Stock.Templates
  @renderForm: ->
    _.template("""
                <input name="stock-search" type="text"><br>
                <button id="stock" data-id="stock-button">Get Stock Data</button><br>
                <div data-id="stock-output"></div>
              """)

  @renderEmptyTable: ->
    _.template("""
                <table data-id="stock-display">
                  <thead>
                    <tr>
                      <th>Name</th>
                      <th>Change</th>
                      <th>Change Percent</th>
                      <th>Change Percent YTD</th>
                      <th>High</th>
                      <th>Low</th>
                      <th>Last Price</th>
                      <th>Market Cap</th>
                      <th>Open</th>
                      <th>Symbol</th>
                      <th>Volume</th>
                      <th>Time Stamp</th>
                    </tr>
                  </thead>
                  <tbody data-id="stock-body">
                  </tbody>
                </table>
                """)

  @renderTableRow: (stockObj) ->
    _.template("""
                <tr>
                  <td><%= stockObj.name %></td>
                  <td><%= stockObj.change %></td>
                  <td><%= stockObj.changePercent %></td>
                  <td><%= stockObj.changePercentYTD %></td>
                  <td><%= stockObj.high %></td>
                  <td><%= stockObj.low %></td>
                  <td><%= stockObj.lastPrice %></td>
                  <td><%= stockObj.marketCap %></td>
                  <td><%= stockObj.open %></td>
                  <td><%= stockObj.symbol %></td>
                  <td><%= stockObj.volume %></td>
                  <td><%= stockObj.timestamp %></td>
                </tr>
                """, {stockObj: stockObj})
