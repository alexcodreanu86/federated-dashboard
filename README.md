## Federated Dashboard


### How to create your own widget

Let's say that we want to build a random widget with the namespace `RandomWidget`.
From the functionality point of view the widget should respond to the following commands:

1.
```javascript
RandomWidget.Controller.setupWidgetIn({container: '#some-container', animationSpeed: 300, otherOption: 'other-option'i, ...more options })
container is a required field
animationSpeed is required as well if you want to use the dashboard with animations
on hide and show forms
```
This command should setup one widget instance in '#some-container' element.
The settings parameter can include any value and as many as are needed for the widget to function as desired.

2.
```javascript
RandomWidget.Controller.hideForms()
```
This command should hide the forms and closing x's of all widget instances running.

3.
```javascript
RandomWidget.Controller.showForms()
```
This command should show the forms and closing x's of all widget instances running.

4.
```javascript
RandomWidget.Display.generateWidgetLogo({class: 'some-class', dataId: 'some-data-id'})
```
This command should generate a valid font-awesome `<i>` tag that also has class 'some-class' and the data-id attribute 'some-data-id'.

For example if we wanted the github icon the return would look something like this:
```html
<i class="fa fa-github some-class" data-id="some-data-id"></i>
```

5.
To be able to use the dashboard widget styling the randomWidget should generate the following html frame into its container:
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

The div with `data-id="random-widget-output"` is where the widget output should be displayed.

The widget functionality is fully up to you here are a few examples of existing widgets code bases:
- [Pictures](https://github.com/bwvoss/federated-dashboard-flickr-widget)
- [Weather](https://github.com/bwvoss/federated-dashboard-wunderground-widget)
- [Stock](https://github.com/bwvoss/federated-dashboard-markitondemand-widget)

### How to include your own widget into the dashboard

In `Dashboard.Widgets.Manager.wrappers` add your widget like this:
```javascript
randomWidget: @wrapWidget({widget:        RandomWidget,
                          name:           'randomWidget',
                          slotSize:       3,
                          animationSpeed: 300,
                          ... and other settings that the widget requires ...})
// widget = widget name space
// name = same as the key coresponding to the wrapper in @wrappers object
// slotSize = the number of slots the widget would be occupying in a column
// these three fields are required for dashboard use, the rest are optional
// animationSpeed = speed to animate forms and sidenav hide and show, include if using animations
// if the new widget accepts a defaultValue field it can also be added to the Dashboard.Widgets.Manager.addDefaultsToWrappers() function like this:
@wrappers.randomWidget.defaultValue = "some default value to search for"
```

If the widget meets the 5 requirements listed in  **How to create your own widget** then you should be able to see that widget logo in the sidenav and you should be all set to use your widget.
