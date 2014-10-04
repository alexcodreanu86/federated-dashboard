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
    function Controller(settings) {
      this.settings = settings;
      this.formsManager = new Dashboard.Widgets.FormsManager(this.animationSpeed());
      this.widgetManager = new Dashboard.Widgets.Manager(settings);
      this.sidenavController = new Dashboard.Sidenav.Controller(this.widgetManager);
      this.widgetSorter = new Dashboard.Widgets.Sorter(this.getSortableList(), this.getSortableHandle());
    }

    Controller.prototype.animationSpeed = function() {
      return this.speed != null ? this.speed : this.speed = this.settings && this.settings.animationSpeed;
    };

    Controller.prototype.getSortableList = function() {
      return this.settings && this.settings.sortableList;
    };

    Controller.prototype.getSortableHandle = function() {
      return this.settings && this.settings.sortableHandle;
    };

    Controller.prototype.initialize = function() {
      this.bindMenuButton();
      this.widgetManager.generateWrappers(this.settings);
      this.initializeDisplay(this.settings);
      return this.sidenavController.bindSetupWidgets();
    };

    Controller.prototype.initializeDisplay = function() {
      this.display = new Dashboard.Display(this.generateDisplaySettings());
      return this.display.initialize();
    };

    Controller.prototype.generateDisplaySettings = function() {
      var displaySettings;
      displaySettings = {
        buttons: this.getButtons()
      };
      displaySettings.animationSpeed = this.animationSpeed();
      return displaySettings;
    };

    Controller.prototype.bindMenuButton = function() {
      return $('[data-id=menu-button]').click((function(_this) {
        return function() {
          return _this.toggleSidenav();
        };
      })(this));
    };

    Controller.prototype.toggleSidenav = function() {
      if (this.display.isSidenavDisplayed()) {
        return this.removeSidenav();
      } else {
        return this.setupSidenav();
      }
    };

    Controller.prototype.setupSidenav = function() {
      this.display.showSidenav();
      this.formsManager.enterEditMode();
      return this.widgetSorter.setupSortable();
    };

    Controller.prototype.getButtons = function() {
      return this.sidenavButtons || (this.sidenavButtons = this.widgetManager.getSidenavButtons());
    };

    Controller.prototype.removeSidenav = function() {
      this.display.hideSidenav();
      this.formsManager.exitEditMode();
      return this.widgetSorter.disableSortable();
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Dashboard');

  Dashboard.Display = (function() {
    var COLUMNS, WIDGETS_BUTTONS_CONTAINER;

    COLUMNS = ['col0', 'col1', 'col2'];

    WIDGETS_BUTTONS_CONTAINER = '[data-id=widget-buttons]';

    function Display(settings) {
      this.settings = settings;
      this.animationSpeed = this.settings.animationSpeed;
    }

    Display.prototype.initialize = function() {
      this.setColumnsHeight();
      this.watchWindowResize();
      this.hideSidenav();
      return this.setupSidenav(this.settings.buttons);
    };

    Display.prototype.setColumnsHeight = function() {
      var windowHeight;
      windowHeight = window.innerHeight;
      return _.forEach(COLUMNS, function(column) {
        return $("[data-id=" + column + "-container]").height(windowHeight);
      });
    };

    Display.prototype.watchWindowResize = function() {
      return $(window).resize((function(_this) {
        return function() {
          return _this.setColumnsHeight();
        };
      })(this));
    };

    Display.prototype.setupSidenav = function(buttons) {
      var contentHtml, data;
      data = {
        buttons: buttons
      };
      contentHtml = new EJS({
        url: 'scripts/dashboard/sidenav/sidenavContent.ejs'
      }).render(data);
      return this.buttonsContainer().html(contentHtml);
    };

    Display.prototype.showSidenav = function() {
      return this.buttonsContainer().show(this.animationSpeed);
    };

    Display.prototype.hideSidenav = function() {
      return this.buttonsContainer().hide(this.animationSpeed);
    };

    Display.prototype.isSidenavDisplayed = function() {
      return this.buttonsContainer().attr('style') !== "display: none;";
    };

    Display.prototype.buttonsContainer = function() {
      return $(WIDGETS_BUTTONS_CONTAINER);
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Sidenav');

  Dashboard.Sidenav.Controller = (function() {
    function Controller(widgetManager) {
      this.widgetManager = widgetManager;
    }

    Controller.prototype.bindSetupWidgets = function() {
      return $('[data-id=widget-buttons] li i').click((function(_this) {
        return function(event) {
          return _this.processClickedButton(event);
        };
      })(this));
    };

    Controller.prototype.processClickedButton = function(event) {
      var button, buttonDataId, widgetName;
      button = $(event.target);
      buttonDataId = button.attr('data-id');
      widgetName = this.getWidgetName(buttonDataId);
      return this.widgetManager.setupWidget(widgetName);
    };

    Controller.prototype.getWidgetName = function(dataId) {
      return dataId.split('-')[0];
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Dashboard.SpeechRecognition');

  Dashboard.SpeechRecognition.Controller = (function() {
    function Controller(dashboardController) {
      this.dashboardController = dashboardController;
    }

    Controller.prototype.commands = {
      'open menu': function() {
        return Controller.showSidenav();
      },
      'close menu': function() {
        return Controller.removeSidenav();
      },
      'do something cool': function() {
        return Controller.showSurprize();
      }
    };

    Controller.prototype.showSidenav = function() {
      return this.dashboardController.setupSidenav();
    };

    Controller.prototype.removeSidenav = function() {
      return this.dashboardController.removeSidenav();
    };

    Controller.prototype.initialize = function() {
      if (annyang) {
        annyang.addCommands(this.commands);
        annyang.debug();
        return annyang.start();
      }
    };

    Controller.prototype.clickOn = function(element) {
      return $(element).click();
    };

    Controller.prototype.dragWidget = function(widget, direction) {
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

    Controller.prototype.dragRight = function(widget) {
      return $("[data-name=" + widget + "].widget-handle").simulate('drag', {
        dx: 350
      });
    };

    Controller.prototype.dragLeft = function(widget) {
      return $("[data-name=" + widget + "].widget-handle").simulate('drag', {
        dx: -350
      });
    };

    Controller.prototype.dragDown = function(widget) {
      var element, parent, parentHeight;
      element = $("[data-id=" + widget + "-slot]");
      parent = element.parent();
      parentHeight = parent.height();
      return $("[data-id=" + widget + "-slot]").simulate('drag', {
        dy: parentHeight
      });
    };

    Controller.prototype.dragUp = function(widget) {
      var distanceToTop, element, parent;
      element = $("[data-id=" + widget + "-slot]");
      parent = element.parent();
      distanceToTop = element.offset().top - parent.offset().top;
      return $("[data-id=" + widget + "-slot]").simulate('drag', {
        dy: -distanceToTop
      });
    };

    Controller.prototype.showSurprize = function() {
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
      return $("[data-id=" + column + "]").addClass('droppable-column');
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Widgets');

  Dashboard.Widgets.FormsManager = (function() {
    function FormsManager(animationSpeed) {
      this.animationSpeed = animationSpeed;
    }

    FormsManager.prototype.exitEditMode = function() {
      $('[data-name=widget-form]').hide(this.animationSpeed);
      return $('[data-name=widget-close]').hide(this.animationSpeed);
    };

    FormsManager.prototype.enterEditMode = function() {
      $('[data-name=widget-form]').show(this.animationSpeed);
      return $('[data-name=widget-close]').show(this.animationSpeed);
    };

    return FormsManager;

  })();

}).call(this);

(function() {
  namespace("Dashboard.Widgets");

  Dashboard.Widgets.Manager = (function() {
    function Manager(settings) {
      this.settings = settings;
    }

    Manager.prototype.generateWrappers = function() {
      this.wrappers = {
        pictures: this.wrapWidget({
          widget: Pictures,
          name: "pictures",
          slotSize: "M",
          key: "key",
          refreshRate: 300,
          slideSpeed: 3000
        }),
        twitter: this.wrapWidget({
          widget: Twitter,
          name: "twitter",
          slotSize: "L",
          refreshRate: 600
        }),
        blog: this.wrapWidget({
          widget: Blog,
          name: "blog",
          slotSize: "M",
          numberOfPosts: 4,
          refreshRate: 600
        }),
        weather: this.wrapWidget({
          widget: Weather,
          name: "weather",
          slotSize: "S",
          key: "key",
          refresh: true
        }),
        stock: this.wrapWidget({
          widget: Stock,
          name: 'stock',
          slotSize: "M"
        }),
        notification: this.wrapWidget({
          widget: Notification,
          name: "notification",
          slotSize: "M",
          refreshRate: 10,
          maxNotifications: 5
        })
      };
      if (this.settings && this.settings.defaults) {
        return this.addDefaultsToWrappers();
      }
    };

    Manager.prototype.wrapWidget = function(settings) {
      return new Dashboard.Widgets.Wrapper(settings);
    };

    Manager.prototype.addDefaultsToWrappers = function() {
      this.wrappers.pictures.defaultValue = '8thLight craftsmen';
      this.wrappers.twitter.defaultValue = '8thLight';
      this.wrappers.weather.defaultValue = 'Chicago IL';
      this.wrappers.blog.defaultValue = 'http://blog.8thlight.com/feed/atom.xml';
      this.wrappers.stock.defaultValue = 'AAPl';
      return this.wrappers.notification.defaultValue = '*@8thlight.com';
    };

    Manager.prototype.getSidenavButtons = function() {
      return _.map(this.getListOfWidgets(), function(wrapper) {
        return wrapper.widgetLogo();
      });
    };

    Manager.prototype.getListOfWidgets = function() {
      return _.values(this.wrappers);
    };

    Manager.prototype.setupWidget = function(name) {
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
    function Sorter(sortableList, handle) {
      this.sortableList = sortableList || '[data-name=sortable-list]';
      this.handle = handle || '[data-name=sortable-handle]';
    }

    Sorter.prototype.setupSortable = function() {
      $(this.sortableList).sortable({
        connectWith: this.sortableList,
        handle: this.handle,
        start: this.startSorting,
        receive: this.receiveSortable,
        stop: function() {
          return $('.droppable-column').removeClass('droppable-column');
        }
      });
      return $(this.sortableList).sortable('enable');
    };

    Sorter.prototype.disableSortable = function() {
      $('.droppable-column').removeClass('droppable-column');
      return $(this.sortableList).sortable('disable');
    };

    Sorter.prototype.startSorting = function(event, ui) {
      var draggedItemSize, senderColumn;
      draggedItemSize = parseInt(ui.item.attr('data-size'));
      senderColumn = $(this).attr('data-id');
      return Dashboard.Widgets.Display.showAvailableColumns(draggedItemSize, senderColumn);
    };

    Sorter.prototype.receiveSortable = function(event, ui) {
      if (!$(this).attr('class').match('droppable-column')) {
        $(ui.sender).sortable("cancel");
      }
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
      this.slotSize = this.getSlotSize(config.slotSize);
      this.config = config;
    }

    Wrapper.prototype.getSlotSize = function(sizeLetter) {
      switch (sizeLetter) {
        case "S":
        case "s":
          return 1;
        case "M":
        case "m":
          return 2;
        default:
          return 3;
      }
    };

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

    return Wrapper;

  })();

}).call(this);
