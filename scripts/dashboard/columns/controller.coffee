namespace("Dashboard.Columns")

class Dashboard.Columns.Controller
  SPACES_PER_COLUMN = 3

  @takenSlots: {
    col0: 0,
    col1: 0,
    col2: 0
  }

  @hasEnoughSlots: (colName, desiredSize) ->
    @takenSlots[colName] + desiredSize <= SPACES_PER_COLUMN

  @emptySlotsInColumn: (slotSize, colName) ->
    @takenSlots[colName] -= slotSize

  @addSlotsToColumn: (slotSize, colName) ->
    @takenSlots[colName] += slotSize

  @generateAvailableSlotFor: (widgetWrapper) ->
    dataId = "#{widgetWrapper.name}-slot"
    size = widgetWrapper.slotSize
    col = @getFirstAvailableColumn(size)
    if col
      @addWidgetContainerToColumn(dataId, col, size)
      {containerName: "[data-id=#{dataId}]", containerColumn: col}

  @addWidgetContainerToColumn: (dataId, col, size) ->
    Dashboard.Columns.Display.appendContainerToColumn(dataId, col)
    @addSlotsToColumn(size, col)

  @getFirstAvailableColumn: (space) ->
    colNames = @getAllAvailableColumns(space)
    colNames[0]

  @getAllAvailableColumns: (space) ->
    colNames = _.map(@takenSlots, (currentSpaces, colName) =>
      if @hasEnoughSlots(colName, space)
        return colName
    )
    _.filter(colNames, (colName) -> colName)

  @activateListsWithAvailableSlots: (wrapper) ->
    availableColumns = @getAllAvailableColumns(wrapper.slotSize)
    availableColumns.push(wrapper.containerColumn)
    _.each(availableColumns, (columnName) ->
      Dashboard.Columns.Display.setColumnAsAvailable(columnName)
    )

  @enterEditMode: ->
    @enableSortableColumns()
    @enableDraggableWidgets()

  @enableDraggableWidgets: ->
    $('.widget').draggable({
      handle: '.widget-handle',
      snap: '.widget-col',
      snapMode: 'inner',
      revert: true,
      revertDuration: 0,
      start: (event, ui) ->
        dataId = $(this).attr('data-id')
        wrapper = Dashboard.Widgets.Manager.getWrapperInContainer("[data-id=#{dataId}]")
        Dashboard.Columns.Controller.activateListsWithAvailableSlots(wrapper)
        Dashboard.Columns.Controller.activateDroppable()
      ,
      stop: ->
        $(this).attr('style', "position: relative;")
    })

  @activateDroppable: ->
    $('.droppable-column').droppable({
      accept: '.widget',
      tolerance: 'pointer',
      drop: (event, ui) ->
        droppedList = $(this).children()[0]
        column = $(droppedList).attr('data-id')
        widgetContainer = $(ui.draggable).attr('data-id')
        wrapper = Dashboard.Widgets.Manager.getWrapperInContainer("[data-id=#{widgetContainer}]")
        if Dashboard.Columns.Controller.hasEnoughSlots(column, wrapper.slotSize)
          $(droppedList).append(ui.draggable)
          Dashboard.Columns.Controller.processDroppedWidgetIn(wrapper, column)

        Dashboard.Columns.Display.removeDroppableColumns()
        Dashboard.Columns.Controller.resetSortableColumns()
        $('.droppable-column').droppable('destroy')
    })

  @disableDraggableWidgets: ->
    $('.widget').draggable('destroy')

  @processDroppedWidgetIn: (wrapper, newColumn) ->
    previousCol = wrapper.containerColumn
    if previousCol != newColumn
      wrapper.containerColumn = newColumn
      @emptySlotsInColumn(wrapper.slotSize, previousCol)
      @addSlotsToColumn(wrapper.slotSize, newColumn)

  @resetSortableColumns: ->
    @disableSortableColumns()
    @enableSortableColumns()

  @enableSortableColumns: ->
    $('.widget-list').sortable({axis: 'y'})

  @disableSortableColumns: ->
    $('.widget-list').sortable('destroy')

  @exitEditMode: ->
    @disableDraggableWidgets()
    @disableSortableColumns()

