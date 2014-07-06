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
      Dashboard.Sidenav.Controller.bindButtons();
      return Dashboard.Widgets.Controller.initialize();
    };

    Controller.bindMenuButton = function() {
      return $('[data-id=menu-button]').click((function(_this) {
        return function() {
          return _this.toggleSidenav();
        };
      })(this));
    };

    Controller.toggleSidenav = function() {
      if (Dashboard.Display.isSidenavDisplayed()) {
        return this.removeSidenav();
      } else {
        return this.setupSidenav();
      }
    };

    Controller.setupSidenav = function() {
      var buttons;
      buttons = Dashboard.Widgets.Manager.getSidenavButtons();
      Dashboard.Display.showSidenav(buttons);
      Dashboard.Sidenav.Controller.rebindButtons();
      return Dashboard.Widgets.Controller.enterEditMode();
    };

    Controller.removeSidenav = function() {
      Dashboard.Display.removeSidenav();
      return Dashboard.Widgets.Controller.exitEditMode();
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Dashboard');

  Dashboard.Display = (function() {
    function Display() {}

    Display.showSidenav = function(buttons) {
      var contentHtml;
      contentHtml = new EJS({
        url: 'scripts/dashboard/sidenav/sidenavContent.ejs'
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

    return Display;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Sidenav');

  Dashboard.Sidenav.Controller = (function() {
    function Controller() {}

    Controller.bindButtons = function() {
      $('[data-id=pictures-widget]').click((function(_this) {
        return function() {
          return Dashboard.Widgets.Controller.checkWidget("pictures");
        };
      })(this));
      $('[data-id=weather-widget]').click((function(_this) {
        return function() {
          return Dashboard.Widgets.Controller.checkWidget("weather");
        };
      })(this));
      $('[data-id=stock-widget]').click((function(_this) {
        return function() {
          return Dashboard.Widgets.Controller.checkWidget("stock");
        };
      })(this));
      return $('[data-id=twitter-widget]').click((function(_this) {
        return function() {
          return Dashboard.Widgets.Controller.checkWidget("twitter");
        };
      })(this));
    };

    Controller.unbind = function() {
      $('[data-id=pictures-widget]').unbind('click');
      $('[data-id=weather-widget]').unbind('click');
      $('[data-id=stock-widget]').unbind('click');
      return $('[data-id=twitter-widget]').unbind('click');
    };

    Controller.rebindButtons = function() {
      this.unbind();
      return this.bindButtons();
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Sidenav');

  Dashboard.Sidenav.Display = (function() {
    function Display() {}

    Display.setButtonActive = function(widgetWrapper) {
      var button;
      button = "[data-id=" + widgetWrapper.name + "-widget]";
      $(button).parent().removeClass('inactive');
      return $(button).parent().addClass('active');
    };

    Display.setButtonInactive = function(widgetWrapper) {
      var button;
      button = "[data-id=" + widgetWrapper.name + "-widget]";
      $(button).parent().removeClass('active');
      return $(button).parent().addClass('inactive');
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Widgets');

  Dashboard.Widgets.Controller = (function() {
    function Controller() {}

    Controller.initialize = function() {
      Dashboard.Widgets.Manager.generateWrappers();
      return this.bindClosingWidgets();
    };

    Controller.checkWidget = function(name) {
      var wrapper;
      wrapper = Dashboard.Widgets.Manager.wrappers[name];
      if (!wrapper.isActive) {
        return this.setupWidget(wrapper);
      }
    };

    Controller.setupWidget = function(wrappedWidget) {
      var containerInfo;
      containerInfo = Dashboard.Widgets.Display.generateAvailableSlotFor(wrappedWidget);
      if (containerInfo) {
        Dashboard.Sidenav.Display.setButtonActive(wrappedWidget);
        wrappedWidget.setupWidgetIn(containerInfo);
        containerInfo = Dashboard.Widgets.Manager.getContainerAndNameOf(wrappedWidget);
        return Dashboard.Widgets.Display.addButtonToContainer(containerInfo);
      }
    };

    Controller.enterEditMode = function() {
      var activeWidgetsInfo;
      activeWidgetsInfo = Dashboard.Widgets.Manager.getActiveWidgetsData();
      Dashboard.Widgets.Display.addClosingButtonsFor(activeWidgetsInfo);
      return Dashboard.Widgets.Manager.showActiveForms();
    };

    Controller.exitEditMode = function() {
      Dashboard.Widgets.Display.removeClosingButtons();
      return Dashboard.Widgets.Manager.hideActiveForms();
    };

    Controller.bindClosingWidgets = function() {
      return $(document).on('click', '.close-widget', (function(_this) {
        return function(event) {
          return _this.getWidgetToBeClosed(event);
        };
      })(this));
    };

    Controller.getWidgetToBeClosed = function(event) {
      var wrapperName;
      wrapperName = $(event.currentTarget).attr('data-name');
      return this.closeWidget(wrapperName);
    };

    Controller.closeWidget = function(wrapperName) {
      var wrappedWidget;
      wrappedWidget = Dashboard.Widgets.Manager.wrappers[wrapperName];
      Dashboard.Widgets.Display.emptySlotsInColumn(wrappedWidget.numberOfSlots, wrappedWidget.containerColumn);
      Dashboard.Sidenav.Display.setButtonInactive(wrappedWidget);
      return wrappedWidget.deactivateWidget();
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Widgets');

  Dashboard.Widgets.Display = (function() {
    var SPACES_PER_COLUMN;

    function Display() {}

    SPACES_PER_COLUMN = 3;

    Display.takenSlots = {
      col0: 0,
      col1: 0,
      col2: 0
    };

    Display.emptySlotsInColumn = function(slotsCount, colName) {
      return this.takenSlots[colName] -= slotsCount;
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
  namespace("Dashboard.Widgets");

  Dashboard.Widgets.Manager = (function() {
    function Manager() {}

    Manager.wrapWidget = function(widget, name, numberOfSlots, apiKey) {
      return new Dashboard.Widgets.Wrapper({
        widget: widget,
        name: name,
        numberOfSlots: numberOfSlots,
        apiKey: apiKey
      });
    };

    Manager.generateWrappers = function() {
      return this.wrappers = {
        pictures: this.wrapWidget(Pictures, "pictures", 3, "a48194703ae0d0d1055d6ded6c4c9869"),
        weather: this.wrapWidget(Weather, "weather", 1, "12ba191e2fec98ad"),
        twitter: this.wrapWidget(Twitter, "twitter", 2, ""),
        stock: this.wrapWidget(Stock, "stock", 2, "")
      };
    };

    Manager.getSidenavButtons = function() {
      var widgets;
      widgets = _.values(Dashboard.Widgets.Manager.wrappers);
      return _.map(widgets, function(wrapper) {
        return wrapper.widgetLogo();
      });
    };

    Manager.getActiveWidgetsData = function() {
      var activeWidgets;
      activeWidgets = this.getActiveWidgets();
      return _.map(activeWidgets, this.getContainerAndNameOf);
    };

    Manager.getActiveWidgets = function() {
      return _.filter(Dashboard.Widgets.Manager.wrappers, function(widget) {
        return widget.isActive;
      });
    };

    Manager.getContainerAndNameOf = function(wrapper) {
      return {
        container: wrapper.containerName,
        name: wrapper.name
      };
    };

    Manager.hideActiveForms = function() {
      var wrappers;
      wrappers = this.getActiveWidgets();
      return _.each(wrappers, function(wrapper) {
        return wrapper.hideWidgetForm();
      });
    };

    Manager.showActiveForms = function() {
      var wrappers;
      wrappers = this.getActiveWidgets();
      return _.each(wrappers, function(wrapper) {
        return wrapper.showWidgetForm();
      });
    };

    return Manager;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Widgets');

  Dashboard.Widgets.Wrapper = (function() {
    var WIDGET_LOGO_WIDTH;

    WIDGET_LOGO_WIDTH = "50";

    Wrapper.prototype.isActive = false;

    function Wrapper(config) {
      this.widget = config.widget;
      this.widgetApiKey = config.apiKey;
      this.name = config.name;
      this.numberOfSlots = config.numberOfSlots;
    }

    Wrapper.prototype.setupWidgetIn = function(containerInfo) {
      this.containerName = containerInfo.containerName;
      this.containerColumn = containerInfo.containerColumn;
      this.isActive = true;
      return this.widget.Controller.setupWidgetIn(this.containerName, this.widgetApiKey);
    };

    Wrapper.prototype.widgetLogo = function() {
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

    Wrapper.prototype.deactivateWidget = function() {
      $(this.containerName).remove();
      return this.isActive = false;
    };

    Wrapper.prototype.addClosingButtonToContainer = function() {
      var dataId;
      dataId = "" + this.name + "-closing-button";
      return $(this.containerName).prepend("<button data-id='" + dataId + "'>X</button>");
    };

    Wrapper.prototype.hideWidgetForm = function() {
      return this.widget.Display.hideForm();
    };

    Wrapper.prototype.showWidgetForm = function() {
      return this.widget.Display.showForm();
    };

    return Wrapper;

  })();

}).call(this);
