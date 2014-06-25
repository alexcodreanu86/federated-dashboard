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
          return _this.setupWidget(Stock.Controller, null);
        };
      })(this));
      $('[data-id=twitter-widget]').click((function(_this) {
        return function() {
          return _this.loadForm('twitter', Twitter.Controller);
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

    Controller.loadForm = function(widget, controller) {
      var form;
      form = Dashboard.Display.generateForm(widget);
      Dashboard.Display.populateWidget(form);
      return controller.bind();
    };

    Controller.setupWidget = function(controller, apiKey) {
      return controller.setupWidgetIn('[data-id=widget-display]', apiKey);
    };

    Controller.toggleSidenav = function() {
      if (Dashboard.Display.isSidenavDisplayed()) {
        Dashboard.Display.removeSidenav();
      } else {
        Dashboard.Display.showSidenav();
      }
      return this.rebind();
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
        url: 'scripts/dashboard/templates/form.ejs'
      }).render({
        widget: widget,
        capitalized: capitalized
      });
    };

    Display.showSidenav = function() {
      var contentHtml;
      contentHtml = new EJS({
        url: 'scripts/dashboard/templates/sidenavContent.ejs'
      }).render({});
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


}).call(this);
