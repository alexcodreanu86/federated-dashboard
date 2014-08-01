namespace('Dashboard.Widgets')

class Dashboard.Widgets.Display
  SPACES_PER_COLUMN = 4
  COLUMNS = ['col0', 'col1', 'col2']

  @containerCount = 0

  @generateContainer: (size) ->
    columnWithSpace = @getFirstAvailableColumn(size)
    if columnWithSpace
      containerId = @getNextContainer()
      @incrementContainerCount()
      $("[data-id=#{columnWithSpace}]").append("<li data-id=#{containerId} data-size=#{size}></li>")
      "[data-id=#{containerId}]"

  @getFirstAvailableColumn: (size) ->
    @getAllAvailableColumns(size)[0]

  @getAllAvailableColumns: (size) ->
    _.filter(COLUMNS, (column) =>
      @hasEnoughSpace(column, size)
    )

  @hasEnoughSpace: (column, neededSpace) ->
    takenSlots = @getColumnSlots(column)
    (takenSlots + neededSpace) <= SPACES_PER_COLUMN

  @getColumnSlots: (column) ->
    total = 0
    containers = $("[data-id=#{column}] li")
    _.forEach(containers, (container) =>
      total += @getContainerSize(container)
    )
    total

  @getContainerSize: (container) ->
    parseInt(container.getAttribute('data-size'))

  @getNextContainer: ->
    "container-#{@containerCount}"

  @incrementContainerCount: ->
    @containerCount++

  @showAvailableColumns: (size) ->
    columns = @getAllAvailableColumns(size)
    _.forEach(columns, (column) =>
      @setAsDroppable(column)
    )

  @setAsDroppable: (column) ->
    $("[data-id=#{column}").addClass('droppable-column')

