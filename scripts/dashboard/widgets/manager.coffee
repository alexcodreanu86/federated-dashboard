namespace("Dashboard.Widgets")

class Dashboard.Widgets.Manager
  @generateWrappers: (settings) ->
    @animationSpeed = settings && settings.animationSpeed
    @wrappers = {
      pictures: @wrapWidget({widget: Pictures, name: "pictures", slotSize: "M", key: "api", animationSpeed: @animationSpeed, refreshRate: 120, slideSpeed: 3000}),
      twitter: @wrapWidget({widget: Twitter, name: "twitter",slotSize:  "L", animationSpeed: @animationSpeed}),
      blog: @wrapWidget({widget: Blog, name: "blog", slotSize: "M", numberOfPosts: 4, animationSpeed: @animationSpeed, refreshRate: 600}),
      weather: @wrapWidget({widget: Weather, name: "weather", slotSize: "S", key: "api", animationSpeed: @animationSpeed, refresh: true})
      stock: @wrapWidget({widget: Stock, name: 'stock', slotSize: "M", animationSpeed: @animationSpeed})
    }
    if settings && settings.defaults
      @addDefaultsToWrappers()

  @wrapWidget: (settings) ->
    new Dashboard.Widgets.Wrapper(settings)

  @addDefaultsToWrappers: ->
    @wrappers.pictures.defaultValue = '8thLight craftsmen'
    @wrappers.twitter.defaultValue = '8thLight'
    @wrappers.weather.defaultValue = 'Chicago IL'
    @wrappers.blog.defaultValue = 'http://blog.8thlight.com/feed/atom.xml'
    @wrappers.stock.defaultValue = 'AAPl'

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
