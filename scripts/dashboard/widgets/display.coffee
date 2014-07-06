namespace('Dashboard.Widgets')

class Dashboard.Widgets.Display
  SPACES_PER_COLUMN = 3

  @takenSlots: {
    col0: 0,
    col1: 0,
    col2: 0
  }

  @emptySlotsInColumn: (slotsCount, colName) ->
    @takenSlots[colName] -= slotsCount

  @generateAvailableSlotFor: (widgetWrapper) ->
    dataId = "#{widgetWrapper.name}-slot"
    size = widgetWrapper.numberOfSlots
    col = @getAvailableColumn(size)
    if col
      @addWidgetContainerToColumn(dataId, col, size)
      {containerName: "[data-id=#{dataId}]", containerColumn: col}

  @addWidgetContainerToColumn: (dataId, col, size) ->
    $("[data-id=#{col}]").append("<div class='widget' data-id='#{dataId}'></div>")
    @takenSlots[col] += size

  @getAvailableColumn: (space) ->
    colNames = _.map(@takenSlots, (currentSpaces, colName) ->
      if ((currentSpaces + space) <= SPACES_PER_COLUMN)
        return colName
    )
    _.find(colNames, (colName) -> colName)

  @addClosingButtonsFor: (activeWidgetsInfo) ->
    _.each(activeWidgetsInfo, @addButtonToContainer)

  @addButtonToContainer: (widgetInfo) ->
    button = "<button class='close-widget' data-name=#{widgetInfo.name}>X</button>"
    $(widgetInfo.container).prepend(button)

  @removeClosingButtons: ->
    $('.close-widget').remove()
