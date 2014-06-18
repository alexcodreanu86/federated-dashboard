#wunderground-widget

Last version is 0.0.3

To install this package you can just add `wunderground-widget: ">0.0.3"` to your dependencies in your bower.js or by executing `bower install wunderground-widget` in the terminal inside your project directory.

To use the widget just add the `dist/federated-dashboard-wunderground-widget.js` to your html file. If you have the widget in the `bower_components` directory. You can just copy the next script tag into the `<head>` of your html file:

```html
<script src="/bower_components/wunderground-widget/dist/federated-dashboard-wunderground-widget.js"></script>
```

Now all you have to do is call `Weather.Controller.setupWidgetIn('.container', 'your_api_key')` where `.container` can be any desired JQuery selector that you want to serve as the container of the widget and `your_api_key` is the api key that you got from [wunderground.com/weather/api](http://www.wunderground.com/weather/api)
