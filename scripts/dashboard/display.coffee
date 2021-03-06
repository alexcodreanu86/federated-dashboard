namespace('Dashboard')

class Dashboard.Display
  COLUMNS = ['col0', 'col1', 'col2']
  WIDGETS_BUTTONS_CONTAINER = '[data-id=widget-buttons]'
  constructor: (@settings) ->
    @animationSpeed = @settings.animationSpeed

  initialize: ->
    @setColumnsHeight()
    @watchWindowResize()
    @hideSidenav()
    @setupSidenav(@settings.buttons)

  setColumnsHeight: ->
    windowHeight = window.innerHeight
    _.forEach(COLUMNS, (column) ->
      $("[data-id=#{column}-container]").height(windowHeight)
    )

  watchWindowResize: ->
    $(window).resize( =>
      @setColumnsHeight()
    )

  setupSidenav: (buttons) ->
    data = {buttons: buttons}
    contentHtml = new EJS({url: 'scripts/dashboard/sidenav/sidenavContent.ejs'}).render(data)
    @buttonsContainer().html(contentHtml)

  showSidenav: () ->
    @buttonsContainer().show(@animationSpeed)

  hideSidenav:() ->
    @buttonsContainer().hide(@animationSpeed)

  isSidenavDisplayed: ->
    @buttonsContainer().attr('style') != "display: none;"

  buttonsContainer: ->
    $(WIDGETS_BUTTONS_CONTAINER)
