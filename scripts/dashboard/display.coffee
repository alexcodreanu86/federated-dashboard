namespace('Dashboard')

SPACES_PER_COLUMN = 3

class Dashboard.Display
  @populateWidget: (html) ->
    $('[data-id=widget-display]').html(html)

  @generateForm: (widget) ->
    capitalized = widget[0].toUpperCase() + widget.slice(1)
    new EJS({url: 'scripts/dashboard/templates/form.ejs'}).render({widget: widget, capitalized: capitalized})

  @showSidenav: (buttons) ->
    contentHtml = new EJS({url: 'scripts/dashboard/templates/sidenavContent.ejs'}).render({buttons: buttons})
    $('[data-id=side-nav]').html(contentHtml)

  @removeSidenav: ->
    $('[data-id=side-nav]').empty()

  @isSidenavDisplayed: ->
    $('[data-id=side-nav]').html().length > 0

  @generateAvailableSlotFor: (size, widgetName) ->
    dataId = "#{widgetName}-slot"
    col = @getAvailableColumn(size)
    if col
      @addWidgetContainerToColumn(dataId, col, size)
      "[data-id=#{dataId}]"

  @addWidgetContainerToColumn: (dataId, col, size) ->
    $("[data-id=#{col}]").append("<div data-id='#{dataId}'></div>")
    @takenSlots[col] += size

  @getAvailableColumn: (space) ->
    colNames = _.map(@takenSlots, (currentSpaces, colName) ->
      if ((currentSpaces + space) <= SPACES_PER_COLUMN)
        return colName
    )
    _.find(colNames, (colName) -> colName)

  @takenSlots: {
    col0: 0,
    col1: 0,
    col2: 0
  }
