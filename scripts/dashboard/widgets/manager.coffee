namespace("Dashboard.Widgets")

class Dashboard.Widgets.Manager
  @generateWrappers: (settings) ->
    @wrappers = {
      pictures: @wrapWidget({widget: Pictures, name: "pictures", slotSize: 2, key: "api_key"}),
      weather: @wrapWidget({widget: Weather, name: "weather", slotSize: 1, key: "weather_api_key"}),
      twitter: @wrapWidget({widget: Twitter, name: "twitter",slotSize:  3}),
      stock: @wrapWidget({widget: Stock, name: "stock", slotSize: 2})
      blog: @wrapWidget({widget: Blog, name: "blog", slotSize: 2, numberOfPosts: 4})
    }
    if settings && settings.defaults
      @addDefaultsToWrappers()

  @wrapWidget: (settings) ->
    new Dashboard.Widgets.Wrapper(settings)

  @addDefaultsToWrappers: ->
    @wrappers.pictures.defaultValue = 'dirtbikes'
    @wrappers.twitter.defaultValue = 'bikes'
    @wrappers.weather.defaultValue = 'Chicago IL'
    @wrappers.stock.defaultValue = 'AAPL YHOO'
    @wrappers.blog.defaultValue = 'http://blog.8thlight.com/feed/atom.xml'

  @enterEditMode: ->
    @mapOnAllWidgets('showWidgetForm')

  @exitEditMode: ->
    @mapOnAllWidgets('hideWidgetForm')

  @getSidenavButtons: ->
    @mapOnAllWidgets('widgetLogo')

  @mapOnAllWidgets: (functionName) ->
    widgets = @getListOfWidgets()
    _.map(widgets, (wrapper) ->
      wrapper[functionName]()
    )

  @getListOfWidgets: ->
    _.values(@wrappers)

  @setupWidget: (name) ->
    wrapper = @wrappers[name]
    container = Dashboard.Widgets.Display.generateContainer(wrapper.slotSize)
    if container
      wrapper.setupWidgetIn(container)
