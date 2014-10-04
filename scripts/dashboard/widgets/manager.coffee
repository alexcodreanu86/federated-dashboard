namespace("Dashboard.Widgets")

class Dashboard.Widgets.Manager
  constructor: (@settings) ->
    @animationSpeed = @settings && @settings.animationSpeed

  generateWrappers: (settings) ->
    @wrappers = {
      pictures: @wrapWidget({widget: Pictures, name: "pictures", slotSize: "M", key: "a48194703ae0d0d1055d6ded6c4c9869", animationSpeed: @animationSpeed, refreshRate: 300, slideSpeed: 3000}),
      twitter: @wrapWidget({widget: Twitter, name: "twitter",slotSize:  "L", refreshRate: 600, animationSpeed: @animationSpeed}),
      blog: @wrapWidget({widget: Blog, name: "blog", slotSize: "M", numberOfPosts: 4, animationSpeed: @animationSpeed, refreshRate: 600}),
      weather: @wrapWidget({widget: Weather, name: "weather", slotSize: "S", key: "f01f2cbcc01e2430", animationSpeed: @animationSpeed, refresh: true})
      stock: @wrapWidget({widget: Stock, name: 'stock', slotSize: "M", animationSpeed: @animationSpeed})
      notification: @wrapWidget({ widget: Notification, name: "notification", slotSize: "M", animationSpeed: @animationSpeed, refreshRate: 10,maxNotifications: 5 }),
    }
    if settings && settings.defaults
      @addDefaultsToWrappers()

  wrapWidget: (settings) ->
    new Dashboard.Widgets.Wrapper(settings)

  addDefaultsToWrappers: ->
    @wrappers.pictures.defaultValue = '8thLight craftsmen'
    @wrappers.twitter.defaultValue = '8thLight'
    @wrappers.weather.defaultValue = 'Chicago IL'
    @wrappers.blog.defaultValue = 'http://blog.8thlight.com/feed/atom.xml'
    @wrappers.stock.defaultValue = 'AAPl'
    @wrappers.notification.defaultValue = '*@8thlight.com'

  getSidenavButtons: ->
    _.map(@getListOfWidgets(), (wrapper) ->
      wrapper.widgetLogo()
    )

  getListOfWidgets: ->
    _.values(@wrappers)

  setupWidget: (name) ->
    wrapper = @wrappers[name]
    container = Dashboard.Widgets.Display.generateContainer(wrapper.slotSize)
    if container
      wrapper.setupWidgetIn(container)
