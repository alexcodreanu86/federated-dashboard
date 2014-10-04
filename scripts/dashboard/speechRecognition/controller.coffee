namespace('Dashboard.SpeechRecognition')

class Dashboard.SpeechRecognition.Controller
  constructor: (dashboardController) ->
    @dashboardController = dashboardController

  commands: {
    'open menu': => @showSidenav()
    'close menu': => @removeSidenav()
    'do something cool': => @showSurprize()
  }

  showSidenav: ->
    @dashboardController.setupSidenav()

  removeSidenav: ->
    @dashboardController.removeSidenav()

  initialize: ->
    if (annyang)
      annyang.addCommands(@commands)
      annyang.debug()
      annyang.start()


  clickOn: (element) ->
    $(element).click()

  dragWidget: (widget, direction) ->
    switch direction[0]
      when "r" then @dragRight(widget)
      when "l" then @dragLeft(widget)
      when "d" then @dragDown(widget)
      when "u" then @dragUp(widget)
      else console.log ('invalid Direction')

  dragRight: (widget) ->
    $("[data-name=#{widget}].widget-handle").simulate('drag', {dx: 350})

  dragLeft: (widget) ->
    $("[data-name=#{widget}].widget-handle").simulate('drag', {dx: -350})

  dragDown: (widget) ->
    element = $("[data-id=#{widget}-slot]")
    parent = element.parent()
    parentHeight = parent.height()
    $("[data-id=#{widget}-slot]").simulate('drag', {dy: parentHeight})

  dragUp: (widget) ->
    element = $("[data-id=#{widget}-slot]")
    parent = element.parent()
    distanceToTop = element.offset().top - parent.offset().top
    $("[data-id=#{widget}-slot]").simulate('drag', {dy: -distanceToTop})

  showSurprize: ->
    window.open("", "_self", "")
    window.close()
