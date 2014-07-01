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
      this.bindMenuButton();
      this.bindSidenavButtons();
      Dashboard.WidgetManager.generateWrappers();
      return this.bindClosingWidgets();
    };

    Controller.bindClosingWidgets = function() {
      return $(document).on('click', '.close-widget', (function(_this) {
        return function(event) {
          return _this.getWidgetToBeClosed(event);
        };
      })(this));
    };

    Controller.bindSidenavButtons = function() {
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
      return $('[data-id=twitter-widget]').click((function(_this) {
        return function() {
          return _this.checkWidget("twitter");
        };
      })(this));
    };

    Controller.unbind = function() {
      $('[data-id=pictures-widget]').unbind('click');
      $('[data-id=weather-widget]').unbind('click');
      $('[data-id=stock-widget]').unbind('click');
      return $('[data-id=twitter-widget]').unbind('click');
    };

    Controller.bindMenuButton = function() {
      return $('[data-id=menu-button]').click((function(_this) {
        return function() {
          return _this.toggleSidenav();
        };
      })(this));
    };

    Controller.rebind = function() {
      this.unbind();
      return this.bindSidenavButtons();
    };

    Controller.getWidgetToBeClosed = function(event) {
      var wrapperName;
      wrapperName = $(event.currentTarget).attr('data-name');
      return this.closeWidget(wrapperName);
    };

    Controller.checkWidget = function(name) {
      var wrapper;
      wrapper = Dashboard.WidgetManager.wrappers[name];
      if (!wrapper.isActive) {
        return this.setupWidget(wrapper);
      }
    };

    Controller.setupWidget = function(wrappedWidget) {
      var containerInfo;
      containerInfo = Dashboard.Display.generateAvailableSlotFor(wrappedWidget);
      if (containerInfo) {
        Dashboard.Display.setSidenavButtonActive(wrappedWidget);
        wrappedWidget.setupWidgetIn(containerInfo);
        containerInfo = Dashboard.WidgetManager.getContainerAndNameOf(wrappedWidget);
        return Dashboard.Display.addButtonToContainer(containerInfo);
      }
    };

    Controller.closeWidget = function(wrapperName) {
      var wrappedWidget;
      wrappedWidget = Dashboard.WidgetManager.wrappers[wrapperName];
      Dashboard.Display.emptySlotsInColumn(wrappedWidget.numberOfSlots, wrappedWidget.containerColumn);
      Dashboard.Display.setSidenavButtonInactive(wrappedWidget);
      return wrappedWidget.closeWidget();
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
      Dashboard.Display.removeSidenav();
      return Dashboard.Display.removeClosingButtons();
    };

    Controller.showSidenav = function() {
      var buttons;
      buttons = Dashboard.WidgetManager.getSidenavButtons();
      Dashboard.Display.showSidenav(buttons);
      return this.enterEditMode();
    };

    Controller.enterEditMode = function() {
      var activeWidgetsInfo;
      activeWidgetsInfo = Dashboard.WidgetManager.getActiveWidgetsData();
      return Dashboard.Display.addClosingButtonsFor(activeWidgetsInfo);
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

    Display.setSidenavButtonActive = function(widgetWrapper) {
      var button;
      button = "[data-id=" + widgetWrapper.name + "-widget]";
      return $(button).parent().addClass('active');
    };

    Display.setSidenavButtonInactive = function(widgetWrapper) {
      var button;
      button = "[data-id=" + widgetWrapper.name + "-widget]";
      return $(button).parent().removeClass('active');
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
        return {
          containerName: "[data-id=" + dataId + "]",
          containerColumn: col
        };
      }
    };

    Display.addWidgetContainerToColumn = function(dataId, col, size) {
      $("[data-id=" + col + "]").append("<div class='widget' data-id='" + dataId + "'></div>");
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

    Display.addClosingButtonsFor = function(activeWidgetsInfo) {
      return _.each(activeWidgetsInfo, this.addButtonToContainer);
    };

    Display.addButtonToContainer = function(widgetInfo) {
      var button;
      button = "<button class='close-widget' data-name=" + widgetInfo.name + ">X</button>";
      return $(widgetInfo.container).prepend(button);
    };

    Display.removeClosingButtons = function() {
      return $('.close-widget').remove();
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace("Dashboard");

  Dashboard.WidgetManager = (function() {
    function WidgetManager() {}

    WidgetManager.wrapWidget = function(widget, name, numberOfSlots, apiKey) {
      return new Dashboard.WidgetWrapper({
        widget: widget,
        name: name,
        numberOfSlots: numberOfSlots,
        apiKey: apiKey
      });
    };

    WidgetManager.generateWrappers = function() {
      return this.wrappers = {
        pictures: this.wrapWidget(Pictures, "pictures", 3, "a48194703ae0d0d1055d6ded6c4c9869"),
        weather: this.wrapWidget(Weather, "weather", 1, "12ba191e2fec98ad"),
        twitter: this.wrapWidget(Twitter, "twitter", 2, ""),
        stock: this.wrapWidget(Stock, "stock", 2, "")
      };
    };

    WidgetManager.getActiveWidgets = function() {
      return _.filter(Dashboard.WidgetManager.wrappers, function(widget) {
        return widget.isActive;
      });
    };

    WidgetManager.getSidenavButtons = function() {
      var widgets;
      widgets = _.values(Dashboard.WidgetManager.wrappers);
      return _.map(widgets, function(wrapper) {
        return wrapper.widgetLogo();
      });
    };

    WidgetManager.getActiveWidgetsData = function() {
      var activeWidgets;
      activeWidgets = this.getActiveWidgets();
      return _.map(activeWidgets, this.getContainerAndNameOf);
    };

    WidgetManager.getContainerAndNameOf = function(wrapper) {
      return {
        container: wrapper.containerName,
        name: wrapper.name
      };
    };

    return WidgetManager;

  })();

}).call(this);

(function() {
  var WIDGET_LOGO_WIDTH;

  namespace('Dashboard');

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
      this.containerName = containerInfo.containerName;
      this.containerColumn = containerInfo.containerColumn;
      this.isActive = true;
      return this.widget.Controller.setupWidgetIn(this.containerName, this.widgetApiKey);
    };

    WidgetWrapper.prototype.widgetLogo = function() {
      var button, dataId;
      dataId = "" + this.name + "-widget";
      button = this.widget.Display.generateLogo({
        dataId: dataId,
        width: WIDGET_LOGO_WIDTH
      });
      return {
        html: button,
        isActive: this.isActive
      };
    };

    WidgetWrapper.prototype.closeWidget = function() {
      $(this.containerName).remove();
      return this.isActive = false;
    };

    WidgetWrapper.prototype.addClosingButtonToContainer = function() {
      var dataId;
      dataId = "" + this.name + "-closing-button";
      $(this.containerName).prepend("<button data-id='" + dataId + "'>X</button>");
      return dataId;
    };

    return WidgetWrapper;

  })();

}).call(this);
