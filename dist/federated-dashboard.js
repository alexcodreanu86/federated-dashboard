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

    Controller.initialize = function(settings) {
      this.bindMenuButton();
      Dashboard.Widgets.Manager.generateWrappers(settings);
      this.initializeDisplay(settings);
      return Dashboard.Sidenav.Controller.bindSetupWidgets();
    };

    Controller.initializeDisplay = function(settings) {
      var displaySettings;
      displaySettings = this.generateDisplaySettings(settings);
      return Dashboard.Display.initialize(displaySettings);
    };

    Controller.generateDisplaySettings = function(settings) {
      var displaySettings;
      displaySettings = {
        buttons: this.getButtons()
      };
      if (settings) {
        displaySettings.animationSpeed = settings.animationSpeed;
      }
      return displaySettings;
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
      Dashboard.Display.showSidenav();
      Dashboard.Widgets.Manager.enterEditMode();
      return Dashboard.Widgets.Sorter.setupSortable();
    };

    Controller.getButtons = function() {
      return this.sidenavButtons || (this.sidenavButtons = Dashboard.Widgets.Manager.getSidenavButtons());
    };

    Controller.removeSidenav = function() {
      Dashboard.Display.hideSidenav();
      Dashboard.Widgets.Manager.exitEditMode();
      return Dashboard.Widgets.Sorter.disableSortable();
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Dashboard');

  Dashboard.Display = (function() {
    var COLUMNS, WIDGETS_BUTTONS_CONTAINER;

    function Display() {}

    COLUMNS = ['col0', 'col1', 'col2'];

    WIDGETS_BUTTONS_CONTAINER = '[data-id=widget-buttons]';

    Display.initialize = function(settings) {
      this.setColumnsHeight();
      this.watchWindowResize();
      this.hideSidenav();
      this.setupSidenav(settings.buttons);
      return this.animationSpeed = settings.animationSpeed;
    };

    Display.setColumnsHeight = function() {
      var windowHeight;
      windowHeight = window.innerHeight;
      return _.forEach(COLUMNS, function(column) {
        return $("[data-id=" + column + "-container]").height(windowHeight);
      });
    };

    Display.watchWindowResize = function() {
      return $(window).resize((function(_this) {
        return function() {
          return _this.setColumnsHeight();
        };
      })(this));
    };

    Display.setupSidenav = function(buttons) {
      var contentHtml, data;
      data = {
        buttons: buttons
      };
      contentHtml = new EJS({
        url: 'scripts/dashboard/sidenav/sidenavContent.ejs'
      }).render(data);
      return this.buttonsContainer().html(contentHtml);
    };

    Display.showSidenav = function() {
      return this.buttonsContainer().show(this.animationSpeed);
    };

    Display.hideSidenav = function() {
      return this.buttonsContainer().hide(this.animationSpeed);
    };

    Display.isSidenavDisplayed = function() {
      return this.buttonsContainer().attr('style') !== "display: none;";
    };

    Display.buttonsContainer = function() {
      return $(WIDGETS_BUTTONS_CONTAINER);
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Sidenav');

  Dashboard.Sidenav.Controller = (function() {
    function Controller() {}

    Controller.bindSetupWidgets = function() {
      return $('[data-id=widget-buttons] li i').click(function() {
        return Dashboard.Sidenav.Controller.processClickedButton(this);
      });
    };

    Controller.processClickedButton = function(button) {
      var buttonDataId, widgetName;
      buttonDataId = button.getAttribute('data-id');
      widgetName = this.getWidgetName(buttonDataId);
      return Dashboard.Widgets.Manager.setupWidget(widgetName);
    };

    Controller.getWidgetName = function(dataId) {
      return dataId.split('-')[0];
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Dashboard.SpeechRecognition');

  Dashboard.SpeechRecognition.Controller = (function() {
    function Controller() {}

    Controller.commands = {
      'open menu': function() {
        return Controller.showSidenav();
      },
      'close menu': function() {
        return Controller.removeSidenav();
      },
      'open :widget widget': function(widget) {
        return Controller.clickOn("[data-id=" + (widget.toLowerCase()) + "-widget]");
      },
      'search :widget for *search': function(widget, search) {
        return Controller.searchWidgetFor(widget.toLowerCase(), search.toLowerCase());
      },
      'close :widget widget': function(widget) {
        return Controller.closeWidget(widget.toLowerCase());
      },
      'move :widget widget :direction': function(widget, direction) {
        return Controller.dragWidget(widget.toLowerCase(), direction.toLowerCase());
      },
      'do something cool': function() {
        return Controller.showSurprize();
      }
    };

    Controller.showSidenav = function() {
      return Dashboard.Controller.setupSidenav();
    };

    Controller.removeSidenav = function() {
      return Dashboard.Controller.removeSidenav();
    };

    Controller.initialize = function() {
      if (annyang) {
        annyang.addCommands(this.commands);
        annyang.debug();
        return annyang.start();
      }
    };

    Controller.searchWidgetFor = function(widget, searchInput) {
      $("[name=" + widget + "-search]").val(searchInput);
      return this.clickOn("[data-id=" + widget + "-button]");
    };

    Controller.openWidget = function(widget) {
      return this.clickOn("[data-id=" + widget + "-widget]");
    };

    Controller.closeWidget = function(widget) {
      return this.clickOn("[data-name=" + widget + "].widget-close");
    };

    Controller.clickOn = function(element) {
      return $(element).click();
    };

    Controller.dragWidget = function(widget, direction) {
      switch (direction[0]) {
        case "r":
          return this.dragRight(widget);
        case "l":
          return this.dragLeft(widget);
        case "d":
          return this.dragDown(widget);
        case "u":
          return this.dragUp(widget);
        default:
          return console.log('invalid Direction');
      }
    };

    Controller.dragRight = function(widget) {
      return $("[data-name=" + widget + "].widget-handle").simulate('drag', {
        dx: 350
      });
    };

    Controller.dragLeft = function(widget) {
      return $("[data-name=" + widget + "].widget-handle").simulate('drag', {
        dx: -350
      });
    };

    Controller.dragDown = function(widget) {
      var element, parent, parentHeight;
      element = $("[data-id=" + widget + "-slot]");
      parent = element.parent();
      parentHeight = parent.height();
      return $("[data-id=" + widget + "-slot]").simulate('drag', {
        dy: parentHeight
      });
    };

    Controller.dragUp = function(widget) {
      var distanceToTop, element, parent;
      element = $("[data-id=" + widget + "-slot]");
      parent = element.parent();
      distanceToTop = element.offset().top - parent.offset().top;
      return $("[data-id=" + widget + "-slot]").simulate('drag', {
        dy: -distanceToTop
      });
    };

    Controller.showSurprize = function() {
      window.open("", "_self", "");
      return window.close();
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Widgets');

  Dashboard.Widgets.Display = (function() {
    var COLUMNS, SPACES_PER_COLUMN;

    function Display() {}

    SPACES_PER_COLUMN = 4;

    COLUMNS = ['col0', 'col1', 'col2'];

    Display.containerCount = 0;

    Display.generateContainer = function(size) {
      var columnWithSpace, containerId;
      columnWithSpace = this.getFirstAvailableColumn(size);
      if (columnWithSpace) {
        containerId = this.getNextContainer();
        this.incrementContainerCount();
        $("[data-id=" + columnWithSpace + "]").append("<li data-id=" + containerId + " data-size=" + size + "></li>");
        return "[data-id=" + containerId + "]";
      }
    };

    Display.getFirstAvailableColumn = function(size) {
      return this.getAllAvailableColumns(size)[0];
    };

    Display.getAllAvailableColumns = function(size) {
      return _.filter(COLUMNS, (function(_this) {
        return function(column) {
          return _this.hasEnoughSpace(column, size);
        };
      })(this));
    };

    Display.hasEnoughSpace = function(column, neededSpace) {
      var takenSlots;
      takenSlots = this.getColumnSlots(column);
      return (takenSlots + neededSpace) <= SPACES_PER_COLUMN;
    };

    Display.getColumnSlots = function(column) {
      var containers, total;
      total = 0;
      containers = $("[data-id=" + column + "] li");
      _.forEach(containers, (function(_this) {
        return function(container) {
          var size;
          size = _this.getContainerSize(container);
          if (size) {
            return total += size;
          }
        };
      })(this));
      return total;
    };

    Display.getContainerSize = function(container) {
      return parseInt(container.getAttribute('data-size'));
    };

    Display.getNextContainer = function() {
      return "container-" + this.containerCount;
    };

    Display.incrementContainerCount = function() {
      return this.containerCount++;
    };

    Display.showAvailableColumns = function(size, senderColumn) {
      var columns;
      columns = this.getAllAvailableColumns(size);
      columns.push(senderColumn);
      return _.forEach(columns, (function(_this) {
        return function(column) {
          return _this.setAsDroppable(column);
        };
      })(this));
    };

    Display.setAsDroppable = function(column) {
      return $("[data-id=" + column).addClass('droppable-column');
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace("Dashboard.Widgets");

  Dashboard.Widgets.Manager = (function() {
    function Manager() {}

    Manager.generateWrappers = function(settings) {
      this.wrappers = {
        pictures: this.wrapWidget({
          widget: Pictures,
          name: "pictures",
          slotSize: 2,
          key: "api_key"
        }),
        weather: this.wrapWidget({
          widget: Weather,
          name: "weather",
          slotSize: 1,
          key: "weather_api_key"
        }),
        twitter: this.wrapWidget({
          widget: Twitter,
          name: "twitter",
          slotSize: 3
        }),
        stock: this.wrapWidget({
          widget: Stock,
          name: "stock",
          slotSize: 2
        }),
        blog: this.wrapWidget({
          widget: Blog,
          name: "blog",
          slotSize: 2,
          numberOfPosts: 4
        })
      };
      if (settings && settings.defaults) {
        return this.addDefaultsToWrappers();
      }
    };

    Manager.wrapWidget = function(settings) {
      return new Dashboard.Widgets.Wrapper(settings);
    };

    Manager.addDefaultsToWrappers = function() {
      this.wrappers.pictures.defaultValue = 'dirtbikes';
      this.wrappers.twitter.defaultValue = 'bikes';
      this.wrappers.weather.defaultValue = 'Chicago IL';
      this.wrappers.stock.defaultValue = 'AAPL YHOO';
      return this.wrappers.blog.defaultValue = 'http://blog.8thlight.com/feed/atom.xml';
    };

    Manager.enterEditMode = function() {
      return this.mapOnAllWidgets('showWidgetForm');
    };

    Manager.exitEditMode = function() {
      return this.mapOnAllWidgets('hideWidgetForm');
    };

    Manager.getSidenavButtons = function() {
      return this.mapOnAllWidgets('widgetLogo');
    };

    Manager.mapOnAllWidgets = function(functionName) {
      var widgets;
      widgets = this.getListOfWidgets();
      return _.map(widgets, function(wrapper) {
        return wrapper[functionName]();
      });
    };

    Manager.getListOfWidgets = function() {
      return _.values(this.wrappers);
    };

    Manager.setupWidget = function(name) {
      var container, wrapper;
      wrapper = this.wrappers[name];
      container = Dashboard.Widgets.Display.generateContainer(wrapper.slotSize);
      if (container) {
        return wrapper.setupWidgetIn(container);
      }
    };

    return Manager;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Widgets');

  Dashboard.Widgets.Sorter = (function() {
    function Sorter() {}

    Sorter.setupSortable = function() {
      $('.widget-list').sortable({
        connectWith: '.widget-list',
        handle: '.widget-header',
        start: function(event, ui) {
          return Dashboard.Widgets.Sorter.startSorting(event, ui, this);
        },
        receive: function(event, ui) {
          return Dashboard.Widgets.Sorter.receiveSortable(event, ui, this);
        },
        stop: this.disableDroppableColumns
      });
      return $('.widget-list').sortable('enable');
    };

    Sorter.disableSortable = function() {
      return $('.widget-list').sortable('disable');
    };

    Sorter.startSorting = function(event, ui, sender) {
      var draggedItemSize, senderColumn;
      draggedItemSize = parseInt(ui.item.attr('data-size'));
      senderColumn = $(sender).attr('data-id');
      return Dashboard.Widgets.Display.showAvailableColumns(draggedItemSize, senderColumn);
    };

    Sorter.receiveSortable = function(event, ui, receiver) {
      if (!$(receiver).attr('class').match('droppable-column')) {
        $(ui.sender).sortable("cancel");
      }
      return this.disableDroppableColumns();
    };

    Sorter.disableDroppableColumns = function() {
      return $('.droppable-column').removeClass('droppable-column');
    };

    return Sorter;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Widgets');

  Dashboard.Widgets.Wrapper = (function() {
    var WIDGET_LOGO_WIDTH;

    WIDGET_LOGO_WIDTH = "50";

    function Wrapper(config) {
      this.widget = config.widget;
      this.name = config.name;
      this.slotSize = config.slotSize;
      this.config = config;
    }

    Wrapper.prototype.setupWidgetIn = function(container) {
      var widgetConfig;
      widgetConfig = _.extend(this.config, {
        container: container,
        defaultValue: this.defaultValue
      });
      return this.widget.Controller.setupWidgetIn(widgetConfig);
    };

    Wrapper.prototype.widgetLogo = function() {
      var settings;
      settings = {
        dataId: "" + this.name + "-widget",
        "class": 'icon'
      };
      return this.widget.Display.generateLogo(settings);
    };

    Wrapper.prototype.hideWidgetForm = function() {
      return this.widget.Controller.hideForms();
    };

    Wrapper.prototype.showWidgetForm = function() {
      return this.widget.Controller.showForms();
    };

    return Wrapper;

  })();

}).call(this);
