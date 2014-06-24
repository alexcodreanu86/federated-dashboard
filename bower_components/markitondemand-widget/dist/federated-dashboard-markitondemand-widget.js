(function(underscore) {
  'use strict';

  window.namespace = function(string, obj) {
    var current = window,
        names = string.split('.'),
        name;

    while((name = names.shift())) {
      current[name] = current[name] || {};
      current = current[name];
    }

    underscore.extend(current, obj);

  };

}(window._));

(function() {
  namespace('Stock');

  Stock.API = (function() {
    function API() {}

    API.loadData = function(symbol, callback) {
      return $.ajax({
        method: 'GET',
        url: 'http://dev.markitondemand.com/Api/v2/Quote/jsonp',
        data: {
          symbol: symbol
        },
        dataType: 'jsonp',
        success: callback,
        error: console.log
      });
    };

    return API;

  })();

}).call(this);

(function() {
  namespace('Stock');

  Stock.Controller = (function() {
    function Controller() {}

    Controller.bind = function() {
      return $('[data-id=stock-button]').click((function(_this) {
        return function() {
          return _this.getStockData(Stock.View.getInput());
        };
      })(this));
    };

    Controller.getStockData = function(searchStr) {
      Stock.View.resetTable();
      return _.each(this.processInput(searchStr), function(symbol) {
        return Stock.API.loadData(symbol, Stock.View.outputData);
      });
    };

    Controller.processInput = function(string) {
      return string.split(/\s+/);
    };

    Controller.setupWidgetIn = function(selector) {
      Stock.View.displayFormIn(selector);
      return this.bind();
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Stock');

  Stock.Templates = (function() {
    function Templates() {}

    Templates.renderForm = function() {
      return _.template("<input name=\"stock-search\" type=\"text\"><br>\n<button id=\"stock\" data-id=\"stock-button\">Get Stock Data</button><br>\n<div data-id=\"stock-output\"></div>");
    };

    Templates.renderEmptyTable = function() {
      return _.template("<table data-id=\"stock-display\">\n  <thead>\n    <tr>\n      <th>Name</th>\n      <th>Change</th>\n      <th>Change Percent</th>\n      <th>Change Percent YTD</th>\n      <th>High</th>\n      <th>Low</th>\n      <th>Last Price</th>\n      <th>Market Cap</th>\n      <th>Open</th>\n      <th>Symbol</th>\n      <th>Volume</th>\n      <th>Time Stamp</th>\n    </tr>\n  </thead>\n  <tbody data-id=\"stock-body\">\n  </tbody>\n</table>");
    };

    Templates.renderTableRow = function(stockObj) {
      return _.template("<tr>\n  <td><%= stockObj.name %></td>\n  <td><%= stockObj.change %></td>\n  <td><%= stockObj.changePercent %></td>\n  <td><%= stockObj.changePercentYTD %></td>\n  <td><%= stockObj.high %></td>\n  <td><%= stockObj.low %></td>\n  <td><%= stockObj.lastPrice %></td>\n  <td><%= stockObj.marketCap %></td>\n  <td><%= stockObj.open %></td>\n  <td><%= stockObj.symbol %></td>\n  <td><%= stockObj.volume %></td>\n  <td><%= stockObj.timestamp %></td>\n</tr>", {
        stockObj: stockObj
      });
    };

    return Templates;

  })();

}).call(this);

(function() {
  namespace('Stock');

  Stock.View = (function() {
    function View() {}

    View.getInput = function() {
      return $('[name=stock-search]').val();
    };

    View.outputData = function(stockObj) {
      var formatedObj, stockHtml;
      formatedObj = Stock.View.formatResponse(stockObj);
      stockHtml = Stock.Templates.renderTableRow(formatedObj);
      return $('[data-id=stock-body]').append(stockHtml);
    };

    View.resetTable = function() {
      var table;
      table = Stock.Templates.renderEmptyTable();
      return $('[data-id=stock-output]').html(table);
    };

    View.displayFormIn = function(container) {
      var formHtml;
      formHtml = Stock.Templates.renderForm();
      return $(container).html(formHtml);
    };

    View.formatResponse = function(response) {
      return {
        name: response.Name,
        symbol: response.Symbol,
        change: response.Change.toFixed(2),
        changePercent: response.ChangePercent.toFixed(2),
        changePercentYTD: response.ChangePercentYTD.toFixed(2),
        open: response.Open.toFixed(2),
        changeYTD: response.ChangeYTD.toFixed(2),
        high: response.High,
        lastPrice: response.LastPrice,
        low: response.Low,
        msDate: response.MSDate.toFixed(2),
        marketCap: response.MarketCap,
        open: response.Open,
        timestamp: response.Timestamp.substr(0, 18),
        volume: response.Volume
      };
    };

    return View;

  })();

}).call(this);
