## Federated Dashboard


### How to create your own widget

Let's say that we want to build a random widget with the namespace RandomWidget.
From the functionality point of view the widget should respond to the following commands:

1. ```javascript RandomWidget.Controller.setupWidgetIn({container: '#some-container', otherOption: 'other-option'i, ...more options })
```
This command should setup one widget instance in '#some-container' element.
The settings parameter can include any value and as many as are needed for the widget to function as desired.

2. ```javascript RandomWidget.Controller.hideForms()```
This command should hide the forms and closing x's of all widget instances running.

3. ```javascript RandomWidget.Controller.showForms()```
This command should show the forms and closing x's of all widget instances running.

4. ```javascript RandomWidget.Display.generateWidgetLogo({class: 'some-class', dataId: 'some-data-id'})
```
This command should generate a valid font-awesome `<i>` that also has class 'some-class' and the data-id attribute 'some-data-id'
For example if we wanted the github icon the return would look something like this:
```html
<i class="fa fa-github some-class" data-id="some-data-id"></i>
```

To be able to use the dashboard widget styling the raw widget html should look like this:
```html
<div class="widget">
  <div class="widget-header">
    <h2 class="widget-title">Random Widget</h2>
    <span class='widget-close' data-id='random-widget-close'>×</span>
    <div class="widget-form" data-id="weather-form">
      <input name="weather-search" type="text">
      <button data-id="random-widget-button">Search Widget</button><br>
    </div>
  </div>
  <div class="widget-body" data-id="random-widget-output">
    ...
    random widget output here
    ...
  </div>
</div>
```

The div with data-id="random-widget-output" is where the widget output should be displayed.

The widget functionality is fully up to you here are a few examples of existing widgets code bases:
- [Pictures](https://github.com/bwvoss/federated-dashboard-flickr-widget)
- [Weather](https://github.com/bwvoss/federated-dashboard-wunderground-widget)
- [Stock](https://github.com/bwvoss/federated-dashboard-markitondemand-widget)

### How to include your own widget into the dashboard

In `Dashboard.Widgets.Manager.generateWrappers()` add your widget like this:
```javascript
randomWidget: @wrapWidget({widget: RandomWidget, name: 'randomWidget', slotSize: 3, ... and other settings that the widget requires ...})

// if you have a defaultValue field you can also add that to the Dashboard.Widgets.Manager.addDefaultsToWrappers() function
```

If the widget meets the 4 requirements listed in  **How to create your own widget** then you should be able to see that widget logo in the sidenav and you should be all set to use your widget.
