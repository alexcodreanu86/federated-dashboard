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

    Controller.initialize = function() {
      this.bind();
      return this.generateWrappedWidgets();
    };

    Controller.bind = function() {
      $('[data-id=pictures-widget]').click((function(_this) {
        return function() {
          return _this.checkWidget("pictures");
        };
      })(this));
      $('[data-id=weather-widget]').click((function(_this) {
        return function() {
          return _this.checkWidget("weather");
        };
      })(this));
      $('[data-id=stock-widget]').click((function(_this) {
        return function() {
          return _this.checkWidget("stock");
        };
      })(this));
      $('[data-id=twitter-widget]').click((function(_this) {
        return function() {
          return _this.checkWidget("twitter");
        };
      })(this));
      return $('[data-id=menu-button]').click((function(_this) {
        return function() {
          return _this.toggleSidenav();
        };
      })(this));
    };

    Controller.unbind = function() {
      $('[data-id=pictures-widget]').unbind('click');
      $('[data-id=weather-widget]').unbind('click');
      $('[data-id=stock-widget]').unbind('click');
      $('[data-id=twitter-widget]').unbind('click');
      return $('[data-id=menu-button]').unbind('click');
    };

    Controller.rebind = function() {
      this.unbind();
      return this.bind();
    };

    Controller.wrapWidget = function(widget, name, apiKey) {
      return new Dashboard.WidgetWrapper({
        widget: widget,
        name: name,
        apiKey: apiKey
      });
    };

    Controller.checkWidget = function(name) {
      var wrapper;
      wrapper = this.wrappedWidgets[name];
      if (!wrapper.isActive) {
        return this.setupWidget(wrapper);
      }
    };

    Controller.setupWidget = function(wrappedWidget) {
      var container;
      container = Dashboard.Display.generateAvailableSlotFor(2, wrappedWidget.name);
      if (container) {
        wrappedWidget.container = container;
        wrappedWidget.isActive = true;
        return wrappedWidget.setupWidget();
      }
    };

    Controller.toggleSidenav = function() {
      var buttons;
      if (Dashboard.Display.isSidenavDisplayed()) {
        Dashboard.Display.removeSidenav();
      } else {
        buttons = this.getSidenavButtons();
        Dashboard.Display.showSidenav(buttons);
      }
      return this.rebind();
    };

    Controller.getSidenavButtons = function() {
      var widgets;
      widgets = _.values(this.generateWrappedWidgets());
      return _.map(widgets, function(wrapper) {
        return wrapper.widgetLogo();
      });
    };

    Controller.generateWrappedWidgets = function() {
      return this.wrappedWidgets = {
        pictures: this.wrapWidget(Pictures, "pictures", "a48194703ae0d0d1055d6ded6c4c9869"),
        weather: this.wrapWidget(Weather, "weather", "12ba191e2fec98ad"),
        twitter: this.wrapWidget(Twitter, "twitter", ""),
        stock: this.wrapWidget(Stock, "stock", "")
      };
    };

    return Controller;

  })();

}).call(this);

(function() {
  var SPACES_PER_COLUMN;

  namespace('Dashboard');

  SPACES_PER_COLUMN = 3;

  Dashboard.Display = (function() {
    function Display() {}

    Display.populateWidget = function(html) {
      return $('[data-id=widget-display]').html(html);
    };

    Display.generateForm = function(widget) {
      var capitalized;
      capitalized = widget[0].toUpperCase() + widget.slice(1);
      return new EJS({
        url: 'scripts/dashboard/templates/form.ejs'
      }).render({
        widget: widget,
        capitalized: capitalized
      });
    };

    Display.showSidenav = function(buttons) {
      var contentHtml;
      contentHtml = new EJS({
        url: 'scripts/dashboard/templates/sidenavContent.ejs'
      }).render({
        buttons: buttons
      });
      return $('[data-id=side-nav]').html(contentHtml);
    };

    Display.removeSidenav = function() {
      return $('[data-id=side-nav]').empty();
    };

    Display.isSidenavDisplayed = function() {
      return $('[data-id=side-nav]').html().length > 0;
    };

    Display.generateAvailableSlotFor = function(size, widgetName) {
      var col, dataId;
      dataId = "" + widgetName + "-slot";
      col = this.getAvailableColumn(size);
      if (col) {
        this.addWidgetContainerToColumn(dataId, col, size);
        return "[data-id=" + dataId + "]";
      }
    };

    Display.addWidgetContainerToColumn = function(dataId, col, size) {
      $("[data-id=" + col + "]").append("<div data-id='" + dataId + "'></div>");
      return this.takenSlots[col] += size;
    };

    Display.getAvailableColumn = function(space) {
      var colNames;
      colNames = _.map(this.takenSlots, function(currentSpaces, colName) {
        if ((currentSpaces + space) <= SPACES_PER_COLUMN) {
          return colName;
        }
      });
      return _.find(colNames, function(colName) {
        return colName;
      });
    };

    Display.takenSlots = {
      col0: 0,
      col1: 0,
      col2: 0
    };

    return Display;

  })();

}).call(this);

(function() {


}).call(this);

(function() {
  namespace('Dashboard');

  Dashboard.WidgetWrapper = (function() {
    function WidgetWrapper(config) {
      this.widget = config.widget;
      this.widgetApiKey = config.apiKey;
      this.name = config.name;
    }

    WidgetWrapper.prototype.setupWidget = function() {
      return this.widget.Controller.setupWidgetIn(this.container, this.widgetApiKey);
    };

    WidgetWrapper.prototype.isActive = false;

    WidgetWrapper.prototype.widgetLogo = function() {
      var dataId;
      dataId = "" + this.name + "-widget";
      return this.widget.Display.generateLogo({
        dataId: dataId,
        width: "50"
      });
    };

    return WidgetWrapper;

  })();

}).call(this);
