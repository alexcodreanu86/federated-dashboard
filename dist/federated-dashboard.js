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
  namespace('Dashboard.SpeechRecognition');

  Dashboard.SpeechRecognition.Controller = (function() {
    function Controller() {}

    Controller.commands = {
      'Dashboard show navigation': function() {
        return Dashboard.Controller.setupSidenav();
      },
      'Dashboard hide navigation': function() {
        return Dashboard.Controller.removeSidenav();
      },
      'Dashboard open *widget widget': function(term) {
        return $("[data-id=" + (term.toLowerCase()) + "-widget]").click();
      }
    };

    Controller.initialize = function() {
      if (annyang) {
        console.log(annyang);
        annyang.addCommands(this.commands);
        annyang.debug();
        return annyang.start();
      }
    };

    Controller.sayHello = function() {
      return console.log("Hello");
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace("Dashboard.Columns");

  Dashboard.Columns.Controller = (function() {
    var SPACES_PER_COLUMN;

    function Controller() {}

    SPACES_PER_COLUMN = 3;

    Controller.takenSlots = {
      col0: 0,
      col1: 0,
      col2: 0
    };

    Controller.hasEnoughSlots = function(colName, desiredSize) {
      return this.takenSlots[colName] + desiredSize <= SPACES_PER_COLUMN;
    };

    Controller.emptySlotsInColumn = function(slotSize, colName) {
      return this.takenSlots[colName] -= slotSize;
    };

    Controller.addSlotsToColumn = function(slotSize, colName) {
      return this.takenSlots[colName] += slotSize;
    };

    Controller.generateAvailableSlotFor = function(widgetWrapper) {
      var col, dataId, size;
      dataId = "" + widgetWrapper.name + "-slot";
      size = widgetWrapper.slotSize;
      col = this.getFirstAvailableColumn(size);
      if (col) {
        this.addWidgetContainerToColumn(dataId, col, size);
        return {
          containerName: "[data-id=" + dataId + "]",
          containerColumn: col
        };
      }
    };

    Controller.addWidgetContainerToColumn = function(dataId, col, size) {
      Dashboard.Columns.Display.appendContainerToColumn(dataId, col);
      return this.addSlotsToColumn(size, col);
    };

    Controller.getFirstAvailableColumn = function(space) {
      var colNames;
      colNames = this.getAllAvailableColumns(space);
      return colNames[0];
    };

    Controller.getAllAvailableColumns = function(space) {
      var colNames;
      colNames = _.map(this.takenSlots, (function(_this) {
        return function(currentSpaces, colName) {
          if (_this.hasEnoughSlots(colName, space)) {
            return colName;
          }
        };
      })(this));
      return _.filter(colNames, function(colName) {
        return colName;
      });
    };

    Controller.activateListsWithAvailableSlots = function(wrapper) {
      var availableColumns;
      availableColumns = this.getAllAvailableColumns(wrapper.slotSize);
      availableColumns.push(wrapper.containerColumn);
      return _.each(availableColumns, function(columnName) {
        return Dashboard.Columns.Display.setColumnAsAvailable(columnName);
      });
    };

    Controller.enterEditMode = function() {
      this.enableSortableColumns();
      return this.enableDraggableWidgets();
    };

    Controller.enableDraggableWidgets = function() {
      return $('.widget').draggable({
        handle: '.widget-handle',
        snap: '.widget-col',
        snapMode: 'inner',
        revert: true,
        revertDuration: 0,
        start: function(event, ui) {
          var dataId, wrapper;
          dataId = $(this).attr('data-id');
          wrapper = Dashboard.Widgets.Manager.getWrapperInContainer("[data-id=" + dataId + "]");
          Dashboard.Columns.Controller.activateListsWithAvailableSlots(wrapper);
          return Dashboard.Columns.Controller.activateDroppable();
        },
        stop: function() {
          return $(this).attr('style', "position: relative;");
        }
      });
    };

    Controller.activateDroppable = function() {
      return $('.droppable-column').droppable({
        accept: '.widget',
        tolerance: 'pointer',
        drop: function(event, ui) {
          var column, droppedList, widgetContainer, wrapper;
          droppedList = $(this).children()[0];
          column = $(droppedList).attr('data-id');
          widgetContainer = $(ui.draggable).attr('data-id');
          wrapper = Dashboard.Widgets.Manager.getWrapperInContainer("[data-id=" + widgetContainer + "]");
          if (Dashboard.Columns.Controller.hasEnoughSlots(column, wrapper.slotSize)) {
            $(droppedList).append(ui.draggable);
            Dashboard.Columns.Controller.processDroppedWidgetIn(wrapper, column);
          }
          Dashboard.Columns.Display.removeDroppableColumns();
          Dashboard.Columns.Controller.resetSortableColumns();
          return $('.droppable-column').droppable('destroy');
        }
      });
    };

    Controller.disableDraggableWidgets = function() {
      return $('.widget').draggable('destroy');
    };

    Controller.processDroppedWidgetIn = function(wrapper, newColumn) {
      var previousCol;
      previousCol = wrapper.containerColumn;
      if (previousCol !== newColumn) {
        wrapper.containerColumn = newColumn;
        this.emptySlotsInColumn(wrapper.slotSize, previousCol);
        return this.addSlotsToColumn(wrapper.slotSize, newColumn);
      }
    };

    Controller.resetSortableColumns = function() {
      this.disableSortableColumns();
      return this.enableSortableColumns();
    };

    Controller.enableSortableColumns = function() {
      return $('.widget-list').sortable({
        axis: 'y'
      });
    };

    Controller.disableSortableColumns = function() {
      return $('.widget-list').sortable('destroy');
    };

    Controller.exitEditMode = function() {
      this.disableDraggableWidgets();
      return this.disableSortableColumns();
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Columns');

  Dashboard.Columns.Display = (function() {
    function Display() {}

    Display.appendContainerToColumn = function(dataId, column) {
      return $("[data-id=" + column + "]").append("<li class='widget' data-id='" + dataId + "'></li>");
    };

    Display.setColumnAsAvailable = function(colDataId) {
      return $("[data-id=" + colDataId + "-container]").addClass('droppable-column');
    };

    Display.removeDroppableColumns = function() {
      $('.droppable-column').removeClass('droppable-column');
      return $('.ui-droppable').removeClass('ui-droppable');
    };

    return Display;

  })();

}).call(this);

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
      Dashboard.Widgets.Controller.enterEditMode();
      return Dashboard.Columns.Controller.enterEditMode();
    };

    Controller.removeSidenav = function() {
      Dashboard.Display.removeSidenav();
      Dashboard.Widgets.Controller.exitEditMode();
      return Dashboard.Columns.Controller.exitEditMode();
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
      return this.clickOn("[data-name=" + widget + "].close-widget");
    };

    Controller.clickOn = function(element) {
      return $(element).click();
    };

    Controller.dragWidget = function(widget, direction) {
      switch (direction) {
        case "right":
          return this.dragRight(widget);
        case "left":
          return this.dragLeft(widget);
        case "down":
          return this.dragDown(widget);
        case "up":
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
      containerInfo = Dashboard.Columns.Controller.generateAvailableSlotFor(wrappedWidget);
      if (containerInfo) {
        Dashboard.Sidenav.Display.setButtonActive(wrappedWidget);
        wrappedWidget.setupWidgetIn(containerInfo);
        containerInfo = Dashboard.Widgets.Manager.getContainerAndNameOf(wrappedWidget);
        Dashboard.Widgets.Display.addButtonAndHandleToContainer(containerInfo);
        return Dashboard.Columns.Controller.enableDraggableWidgets();
      }
    };

    Controller.enterEditMode = function() {
      var activeWidgetsInfo;
      activeWidgetsInfo = Dashboard.Widgets.Manager.getActiveWidgetsData();
      Dashboard.Widgets.Display.addEditingButtonsFor(activeWidgetsInfo);
      return Dashboard.Widgets.Manager.showActiveForms();
    };

    Controller.exitEditMode = function() {
      Dashboard.Widgets.Display.removeEditButtons();
      return Dashboard.Widgets.Manager.hideActiveForms();
    };

    Controller.bindClosingWidgets = function() {
      return $(document).on('click', '.close-widget', (function(_this) {
        return function(event) {
          var wrapperName;
          wrapperName = _this.getWidgetToBeClosed(event);
          return _this.closeWidget(wrapperName);
        };
      })(this));
    };

    Controller.getWidgetToBeClosed = function(event) {
      var wrapperName;
      return wrapperName = $(event.currentTarget).attr('data-name');
    };

    Controller.closeWidget = function(wrapperName) {
      var wrappedWidget;
      wrappedWidget = Dashboard.Widgets.Manager.wrappers[wrapperName];
      Dashboard.Columns.Controller.emptySlotsInColumn(wrappedWidget.slotSize, wrappedWidget.containerColumn);
      Dashboard.Sidenav.Display.setButtonInactive(wrappedWidget);
      return wrappedWidget.deactivateWidget();
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Widgets');

  Dashboard.Widgets.Display = (function() {
    function Display() {}

    Display.addEditingButtonsFor = function(activeWidgetsInfo) {
      return _.each(activeWidgetsInfo, (function(_this) {
        return function(widgetInfo) {
          return _this.addButtonAndHandleToContainer(widgetInfo);
        };
      })(this));
    };

    Display.addButtonAndHandleToContainer = function(widgetInfo) {
      this.addButtonToContainer(widgetInfo);
      return this.addHandleToContainer(widgetInfo);
    };

    Display.addButtonToContainer = function(widgetInfo) {
      var button;
      button = Dashboard.Widgets.Templates.generateClosingButton(widgetInfo.name);
      return $(widgetInfo.container).prepend(button);
    };

    Display.addHandleToContainer = function(widgetInfo) {
      var handle;
      handle = Dashboard.Widgets.Templates.generateHandle(widgetInfo.name);
      return $(widgetInfo.container).prepend(handle);
    };

    Display.removeEditButtons = function() {
      this.removeClosingButtons();
      return this.removeDraggingHandles();
    };

    Display.removeClosingButtons = function() {
      return $('.close-widget').remove();
    };

    Display.removeDraggingHandles = function() {
      return $('.widget-handle').remove();
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace("Dashboard.Widgets");

  Dashboard.Widgets.Manager = (function() {
    function Manager() {}

    Manager.generateWrappers = function() {
      return this.wrappers = {
        pictures: this.wrapWidget(Pictures, "pictures", 3, "a48194703ae0d0d1055d6ded6c4c9869"),
        weather: this.wrapWidget(Weather, "weather", 1, "12ba191e2fec98ad"),
        twitter: this.wrapWidget(Twitter, "twitter", 2, ""),
        stock: this.wrapWidget(Stock, "stock", 2, "")
      };
    };

    Manager.wrapWidget = function(widget, name, slotSize, apiKey) {
      return new Dashboard.Widgets.Wrapper({
        widget: widget,
        name: name,
        slotSize: slotSize,
        apiKey: apiKey
      });
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

    Manager.getWrapperInContainer = function(containerName) {
      return _.findWhere(this.wrappers, {
        containerName: containerName
      });
    };

    return Manager;

  })();

}).call(this);

(function() {
  namespace('Dashboard.Widgets');

  Dashboard.Widgets.Templates = (function() {
    function Templates() {}

    Templates.generateClosingButton = function(dataName) {
      return "<button class='close-widget' data-name='" + dataName + "'>X</button>";
    };

    Templates.generateHandle = function(dataName) {
      return "<p class='widget-handle' data-name=" + dataName + ">Handle</p>";
    };

    return Templates;

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
      this.slotSize = config.slotSize;
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
