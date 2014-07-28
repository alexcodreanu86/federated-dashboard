namespace('Dashboard.Widgets')

class Dashboard.Widgets.Display
  @addEditingButtonsFor: (activeWidgetsInfo) ->
    _.each(activeWidgetsInfo,(widgetInfo)  =>
      @addHandleToContainer(widgetInfo)
    )

  @addHandleToContainer: (widgetInfo) ->
    handle = Dashboard.Widgets.Templates.generateHandle(widgetInfo.name)
    $(widgetInfo.container).prepend(handle)

  @removeEditButtons: ->
    @removeDraggingHandles()

  @removeDraggingHandles: ->
    $('.widget-handle').remove()
