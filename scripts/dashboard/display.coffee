namespace('Dashboard')

SPACES_PER_COLUMN = 3

class Dashboard.Display

  @takenSlots: {
    col0: 0,
    col1: 0,
    col2: 0
  }

  @emptySlotsInColumn: (slotsCount, colName) ->
    @takenSlots[colName] -= slotsCount

  @populateWidget: (html) ->
    $('[data-id=widget-display]').html(html)

  @showSidenav: (buttons) ->
    contentHtml = new EJS({url: 'scripts/dashboard/templates/sidenavContent.ejs'}).render({buttons: buttons})
    $('[data-id=side-nav]').html(contentHtml)

  @removeSidenav: ->
    $('[data-id=side-nav]').empty()

  @isSidenavDisplayed: ->
    $('[data-id=side-nav]').html().length > 0

  @generateAvailableSlotFor: (widgetWrapper) ->
    dataId = "#{widgetWrapper.name}-slot"
    size = widgetWrapper.numberOfSlots
    col = @getAvailableColumn(size)
    if col
      @addWidgetContainerToColumn(dataId, col, size)
      ["[data-id=#{dataId}]", col]

  @addWidgetContainerToColumn: (dataId, col, size) ->
    $("[data-id=#{col}]").append("<div data-id='#{dataId}'></div>")
    @takenSlots[col] += size

  @getAvailableColumn: (space) ->
    colNames = _.map(@takenSlots, (currentSpaces, colName) ->
      if ((currentSpaces + space) <= SPACES_PER_COLUMN)
        return colName
    )
    _.find(colNames, (colName) -> colName)
