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

    Controller.checkWidget = function(name) {
      var wrapper;
      wrapper = this.wrappedWidgets[name];
      if (!wrapper.isActive) {
        return this.setupWidget(wrapper);
      }
    };

    Controller.setupWidget = function(wrappedWidget) {
      var containerInfo;
      containerInfo = Dashboard.Display.generateAvailableSlotFor(wrappedWidget);
      if (containerInfo) {
        return wrappedWidget.setupWidgetIn(containerInfo);
      }
    };

    Controller.toggleSidenav = function() {
      if (Dashboard.Display.isSidenavDisplayed()) {
        this.removeSidenav();
      } else {
        this.showSidenav();
      }
      return this.rebind();
    };

    Controller.removeSidenav = function() {
      return Dashboard.Display.removeSidenav();
    };

    Controller.showSidenav = function() {
      var buttons;
      buttons = this.getSidenavButtons();
      return Dashboard.Display.showSidenav(buttons);
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
        pictures: this.wrapWidget(Pictures, "pictures", 3, "a48194703ae0d0d1055d6ded6c4c9869"),
        weather: this.wrapWidget(Weather, "weather", 1, "12ba191e2fec98ad"),
        twitter: this.wrapWidget(Twitter, "twitter", 2, ""),
        stock: this.wrapWidget(Stock, "stock", 2, "")
      };
    };

    Controller.wrapWidget = function(widget, name, numberOfSlots, apiKey) {
      return new Dashboard.WidgetWrapper({
        widget: widget,
        name: name,
        numberOfSlots: numberOfSlots,
        apiKey: apiKey
      });
    };

    Controller.closeWidget = function(wrapperName) {
      var wrappedWidget;
      wrappedWidget = this.wrappedWidgets[wrapperName];
      Dashboard.Display.emptySlotsInColumn(wrappedWidget.numberOfSlots, wrappedWidget.containerColumn);
      return wrappedWidget.closeWidget();
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

    Display.takenSlots = {
      col0: 0,
      col1: 0,
      col2: 0
    };

    Display.emptySlotsInColumn = function(slotsCount, colName) {
      return this.takenSlots[colName] -= slotsCount;
    };

    Display.populateWidget = function(html) {
      return $('[data-id=widget-display]').html(html);
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

    Display.generateAvailableSlotFor = function(widgetWrapper) {
      var col, dataId, size;
      dataId = "" + widgetWrapper.name + "-slot";
      size = widgetWrapper.numberOfSlots;
      col = this.getAvailableColumn(size);
      if (col) {
        this.addWidgetContainerToColumn(dataId, col, size);
        return ["[data-id=" + dataId + "]", col];
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

    return Display;

  })();

}).call(this);

(function() {


}).call(this);

(function() {
  var INDEX_OF_CONTAINER_COLUMN, INDEX_OF_CONTAINER_NAME, WIDGET_LOGO_WIDTH;

  namespace('Dashboard');

  INDEX_OF_CONTAINER_NAME = 0;

  INDEX_OF_CONTAINER_COLUMN = 1;

  WIDGET_LOGO_WIDTH = "50";

  Dashboard.WidgetWrapper = (function() {
    WidgetWrapper.prototype.isActive = false;

    function WidgetWrapper(config) {
      this.widget = config.widget;
      this.widgetApiKey = config.apiKey;
      this.name = config.name;
      this.numberOfSlots = config.numberOfSlots;
    }

    WidgetWrapper.prototype.setupWidgetIn = function(containerInfo) {
      this.containerName = containerInfo[INDEX_OF_CONTAINER_NAME];
      this.containerColumn = containerInfo[INDEX_OF_CONTAINER_COLUMN];
      this.isActive = true;
      return this.widget.Controller.setupWidgetIn(this.containerName, this.widgetApiKey);
    };

    WidgetWrapper.prototype.widgetLogo = function() {
      var dataId;
      dataId = "" + this.name + "-widget";
      return this.widget.Display.generateLogo({
        dataId: dataId,
        width: WIDGET_LOGO_WIDTH
      });
    };

    WidgetWrapper.prototype.closeWidget = function() {
      $(this.containerName).remove();
      return this.isActive = false;
    };

    return WidgetWrapper;

  })();

}).call(this);
