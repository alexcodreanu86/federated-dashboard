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
  namespace('Pictures');

  Pictures.API = (function() {
    function API() {}

    API.search = function(searchString, callback) {
      var flickr;
      flickr = new Flickr({
        api_key: "a48194703ae0d0d1055d6ded6c4c9869"
      });
      return flickr.photos.search({
        text: searchString,
        per_page: 6,
        extras: "url_n"
      }, function(err, response) {
        if (err) {
          throw new Error(err);
        }
        return callback(response.photos.photo);
      });
    };

    return API;

  })();

}).call(this);

(function() {
  namespace('Pictures');

  Pictures.Controller = (function() {
    function Controller() {}

    Controller.loadImages = function(searchStr) {
      return Pictures.API.search(searchStr, Pictures.Display.addImages);
    };

    Controller.bind = function() {
      return $('[data-id=flickr-button]').click((function(_this) {
        return function() {
          return _this.loadImages(Pictures.Display.getInput());
        };
      })(this));
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Pictures');

  Pictures.Display = (function() {
    function Display() {}

    Display.getInput = function() {
      return $('[name=flickr-search]').val();
    };

    Display.addImages = function(images) {
      var imagesHtml;
      imagesHtml = new EJS({
        url: 'scripts/pictures/template.ejs'
      }).render({
        images: images
      });
      return $('[data-id=flickr-images]').html(imagesHtml);
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace('Flick');

  Flick.Wrapper = (function() {
    function Wrapper() {}

    Wrapper.getParser = function() {
      var flickr;
      flickr = new Flickr({
        api_key: "a48194703ae0d0d1055d6ded6c4c9869"
      });
      return flickr.photos;
    };

    return Wrapper;

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
          return _this.getStockData(Stock.Display.getInput());
        };
      })(this));
    };

    Controller.getStockData = function(searchStr) {
      Stock.Display.resetTable();
      return _.each(this.processInput(searchStr), function(symbol) {
        return Stock.API.loadData(symbol, Stock.Display.outputData);
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

  Stock.Display = (function() {
    function Display() {}

    Display.getInput = function() {
      return $('[name=stock-search]').val();
    };

    Display.outputData = function(stockObj) {
      var stockHtml;
      stockHtml = new EJS({
        url: 'scripts/stock/tRowTemplate.ejs'
      }).render(stockObj);
      return $('[data-id=stock-body]').append(stockHtml);
    };

    Display.resetTable = function() {
      var table;
      table = new EJS({
        url: 'scripts/stock/tableTemplate.ejs'
      }).render({});
      return $('[data-id=stock-output]').html(table);
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace('Weather');

  Weather.API = (function() {
    function API() {}

    API.getCurrentConditions = function(zipcode, callback) {
      return $.get("http://api.wunderground.com/api/12ba191e2fec98ad/conditions/q/" + zipcode + ".json", function(response) {
        callback(response.current_observation);
        return response;
      }, "jsonp");
    };

    return API;

  })();

}).call(this);

(function() {
  namespace('Weather');

  Weather.Controller = (function() {
    function Controller() {}

    Controller.bind = function() {
      return $('[data-id=weather-button]').click((function(_this) {
        return function() {
          return _this.getCurrentWeather(Weather.Display.getInput());
        };
      })(this));
    };

    Controller.getCurrentWeather = function(zipcode) {
      return Weather.Wrapper.getCurrentConditions(zipcode, Weather.Display.showWeather);
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Weather');

  Weather.Display = (function() {
    function Display() {}

    Display.getInput = function() {
      return $('[name=weather-search]').val();
    };

    Display.showWeather = function(weatherObj) {
      var weatherHTML;
      weatherHTML = Weather.Display.generateHtml(weatherObj);
      return $('[data-id=weather-output]').html(weatherHTML);
    };

    Display.generateHtml = function(weatherObj) {
      return new EJS({
        url: 'scripts/weather/template.ejs'
      }).render(weatherObj);
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace('Weather');

  Weather.Wrapper = (function() {
    function Wrapper() {}

    Wrapper.getCurrentConditions = function(zipcode, callback) {
      return $.get("http://api.wunderground.com/api/12ba191e2fec98ad/conditions/q/" + zipcode + ".json", function(response) {
        callback(response.current_observation);
        return response;
      }, "jsonp");
    };

    return Wrapper;

  })();

}).call(this);
