## Federated Dashboard
---
### What is it?

The idea behind creating the Federated Dashboard was to have a dashboard that is easy to use and customize. Each widget in it is a separate bower component that is included in the `dependencies` section of `bower.json`. Each widget setup adds one line of code with the setup settings and one `<script>` tag in the view to load the source file/files of the widget. The widgets are fully functional mini applications. The dashboard acts as a coordonator for all the widgets to function properly together.

### How to use the dashboard

1. After cloning this repo, inside the cloned directory run `bower install` to install all the bower components and `npm install` to install all the node dependencies.

2. Some widgets will require API keys that can be requested from the api provider. API keys will have to be setup in the `Dashboard.Widgets.Manager.widgets`, in the `key` fields.

For twitter widget the keys will have to be set as environment variables:
```
export TWITTER_API_KEY=twitterapikey
export TWITTER_API_SECRET=twitterapisecret
export TWITTER_ACCESS_TOKEN=twitteraccesstoken
export TWITTER_ACCESS_TOKEN_SECRET=twitteraccesstokensecret
```
Here are some API providers for the coresponding widgets:

+ Pictures: [flickr](https://www.flickr.com/services/api/)
+ Weather:  [wunderground](http://www.wunderground.com/weather/api/)
+ Twitter:  [twitter](https://dev.twitter.com/)

3. To compile the changes in the CoffeeScript files run `grunt`. This will recompile the dashboard code files inside `dist/` and the `server.js` file.

4. And the last step is to start your server. By Executing the command `node server.js` the application should be available at (localhost:5000)[http://localhost:5000].

### How to create your own widget

Let's say that we want to build a random widget with the namespace `RandomWidget`.
From the functionality point of view the widget should respond to the following commands:

1.
```javascript
RandomWidget.Controller.setupWidgetIn({container: '#some-container', animationSpeed: 300, otherOption: 'other-option'i, ...more options })
// container is a required field
// animationSpeed is required as well if you want to use the dashboard with animations
// on hide and show forms
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

If the widget is added as a bower component, the widget scripts will have to be added to `views/index.ejs`

If the widget meets the 5 requirements listed in  **How to create your own widget** then you should be able to see that widget logo in the sidenav and you should be all set to use your widget.

For widgets that require backend logic, new routes can be added to `scripts/server.coffee`. The compiled version of this file is `server.js` in the root directory.
