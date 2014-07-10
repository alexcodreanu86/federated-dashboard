namespace('Dashboard.Widgets')

class Dashboard.Widgets.Display
  @addEditingButtonsFor: (activeWidgetsInfo) ->
    _.each(activeWidgetsInfo,(widgetInfo)  =>
      @addButtonAndHandleToContainer(widgetInfo)
    )

  @addButtonAndHandleToContainer: (widgetInfo) ->
    @addButtonToContainer(widgetInfo)
    @addHandleToContainer(widgetInfo)

  @addButtonToContainer: (widgetInfo) ->
    button = Dashboard.Widgets.Templates.generateClosingButton(widgetInfo.name)
    $(widgetInfo.container).prepend(button)

  @addHandleToContainer: (widgetInfo) ->
    handle = Dashboard.Widgets.Templates.generateHandle(widgetInfo.name)
    $(widgetInfo.container).prepend(handle)

  @removeEditButtons: ->
    @removeClosingButtons()
    @removeDraggingHandles()

  @removeClosingButtons: ->
    $('.close-widget').remove()

  @removeDraggingHandles: ->
    $('.widget-handle').remove()
