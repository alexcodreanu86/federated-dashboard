namespace('Dashboard.Widgets')

class Dashboard.Widgets.Sorter
  @setupSortable: ->
    $('.widget-list').sortable({
      connectWith: '.widget-list',
      handle: '.widget-header',
      start: (event, ui) ->
        Dashboard.Widgets.Sorter.startSorting(event, ui, this)
      receive: (event, ui) ->
        Dashboard.Widgets.Sorter.receiveSortable(event, ui, this)
      stop: @disableDroppableColumns
    })
    $('.widget-list').sortable('enable')

  @disableSortable: ->
    $('.widget-list').sortable('disable')

  @startSorting: (event, ui, sender) ->
    draggedItemSize = parseInt(ui.item.attr('data-size'))
    senderColumn = $(sender).attr('data-id')
    Dashboard.Widgets.Display.showAvailableColumns(draggedItemSize, senderColumn)

  @receiveSortable: (event, ui, receiver) ->
    if !$(receiver).attr('class').match('droppable-column')
      $(ui.sender).sortable("cancel")
    @disableDroppableColumns()

  @disableDroppableColumns: ->
    $('.droppable-column').removeClass('droppable-column')
