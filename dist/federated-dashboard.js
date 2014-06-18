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
  namespace('Dashboard');

  Dashboard.Controller = (function() {
    function Controller() {}

    Controller.bind = function() {
      $('[data-id=pictures-widget]').click((function(_this) {
        return function() {
          return _this.setupWidget(Pictures.Controller, 'a48194703ae0d0d1055d6ded6c4c9869');
        };
      })(this));
      $('[data-id=weather-widget]').click((function(_this) {
        return function() {
          return _this.setupWidget(Weather.Controller, '12ba191e2fec98ad');
        };
      })(this));
      $('[data-id=stock-widget]').click((function(_this) {
        return function() {
          return _this.loadForm('stock', Stock.Controller);
        };
      })(this));
      return $('[data-id=twitter-widget]').click((function(_this) {
        return function() {
          return _this.loadForm('twitter', Twitter.Controller);
        };
      })(this));
    };

    Controller.loadForm = function(widget, controller) {
      var form;
      form = Dashboard.Display.generateForm(widget);
      Dashboard.Display.populateWidget(form);
      return controller.bind();
    };

    Controller.setupWidget = function(controller, apiKey) {
      return controller.setupWidgetIn('[data-id=widget-display]', apiKey);
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Dashboard');

  Dashboard.Display = (function() {
    function Display() {}

    Display.populateWidget = function(html) {
      return $('[data-id=widget-display]').html(html);
    };

    Display.generateForm = function(widget) {
      var capitalized;
      capitalized = widget[0].toUpperCase() + widget.slice(1);
      return new EJS({
        url: 'scripts/frontEnd/dashboard/formTemplate.ejs'
      }).render({
        widget: widget,
        capitalized: capitalized
      });
    };

    return Display;

  })();

}).call(this);

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

    return Controller;

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
      stockHtml = new EJS({
        url: 'scripts/frontEnd/stock/tRowTemplate.ejs'
      }).render(formatedObj);
      return $('[data-id=stock-body]').append(stockHtml);
    };

    View.resetTable = function() {
      var table;
      table = new EJS({
        url: 'scripts/frontEnd/stock/tableTemplate.ejs'
      }).render({});
      return $('[data-id=stock-output]').html(table);
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

(function() {
  namespace('Twitter');

  Twitter.Controller = (function() {
    function Controller() {}

    Controller.bind = function() {
      return $('[data-id=twitter-button]').click((function(_this) {
        return function() {
          return _this.getTweeterPosts(Twitter.View.getInput());
        };
      })(this));
    };

    Controller.getTweeterPosts = function(searchInput) {
      var url;
      url = this.generateUrl(searchInput);
      return $.get(url, function(response) {
        return Twitter.View.displayTweets(response);
      }, 'json');
    };

    Controller.generateUrl = function(input) {
      return "/search_twitter/" + input;
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Twitter');

  Twitter.View = (function() {
    function View() {}

    View.getInput = function() {
      return $('[name=twitter-search]').val();
    };

    View.generateHtml = function(twitterResponse) {
      return new EJS({
        url: 'scripts/frontEnd/twitter/template.ejs'
      }).render({
        statuses: twitterResponse
      });
    };

    View.displayTweets = function(twitterResponse) {
      var twitterHtml;
      twitterHtml = this.generateHtml(twitterResponse);
      return $('[data-id=twitter-output]').html(twitterHtml);
    };

    return View;

  })();

}).call(this);
