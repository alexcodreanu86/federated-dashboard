namespace('Dashboard.SpeechRecognition')

class Dashboard.SpeechRecognition.Controller
  @commands: {
    'open menu': => @showSidenav()
    'close menu': => @removeSidenav()
    'open :widget widget': (widget) => @clickOn("[data-id=#{widget.toLowerCase()}-widget]")
    'search :widget for *search': (widget, search) =>
      @searchWidgetFor(widget.toLowerCase(), search.toLowerCase())
    'close :widget widget': (widget) => @closeWidget(widget.toLowerCase())
    'move :widget widget :direction': (widget, direction) => @dragWidget(widget.toLowerCase(), direction.toLowerCase())
    'do something cool': => @showSurprize()
  }

  @showSidenav: ->
    Dashboard.Controller.setupSidenav()

  @removeSidenav: ->
    Dashboard.Controller.removeSidenav()

  @initialize: ->
    if (annyang)
      annyang.addCommands(@commands)
      annyang.debug()
      annyang.start()

  @searchWidgetFor: (widget, searchInput) ->
    $("[name=#{widget}-search]").val(searchInput)
    @clickOn("[data-id=#{widget}-button]")

  @openWidget: (widget) ->
    @clickOn("[data-id=#{widget}-widget]")

  @closeWidget: (widget) ->
    @clickOn("[data-name=#{widget}].close-widget")

  @clickOn: (element) ->
    $(element).click()

  @dragWidget: (widget, direction) ->
    switch direction
      when "right" then @dragRight(widget)
      when "left" then @dragLeft(widget)
      when "down" then @dragDown(widget)
      when "up" then @dragUp(widget)
      else console.log ('invalid Direction')

  @dragRight: (widget) ->
    $("[data-name=#{widget}].widget-handle").simulate('drag', {dx: 350})

  @dragLeft: (widget) ->
    $("[data-name=#{widget}].widget-handle").simulate('drag', {dx: -350})

  @dragDown: (widget) ->
    element = $("[data-id=#{widget}-slot]")
    parent = element.parent()
    parentHeight = parent.height()

    $("[data-id=#{widget}-slot]").simulate('drag', {dy: parentHeight})

  @dragUp: (widget) ->
    element = $("[data-id=#{widget}-slot]")
    parent = element.parent()
    distanceToTop = element.offset().top - parent.offset().top
    $("[data-id=#{widget}-slot]").simulate('drag', {dy: -distanceToTop})

  @showSurprize: ->
    window.open("", "_self", "")
    window.close()
