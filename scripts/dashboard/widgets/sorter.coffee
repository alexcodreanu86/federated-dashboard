namespace('Dashboard.Widgets')

class Dashboard.Widgets.Sorter
  constructor: (sortableList, handle) ->
    @sortableList = sortableList || '.widget-list'
    @handle       = handle       || '.widget-header'
  setupSortable: ->
    $(@sortableList).sortable({
      connectWith: @sortableList,
      handle: @handle,
      start: @startSorting
      receive: @receiveSortable
      stop: @disableDroppableColumns
    })
    $(@sortableList).sortable('enable')

  disableSortable: ->
    $(@sortableList).sortable('disable')

  startSorting: (event, ui) ->
    draggedItemSize = parseInt(ui.item.attr('data-size'))
    senderColumn = $(this).attr('data-id')
    Dashboard.Widgets.Display.showAvailableColumns(draggedItemSize, senderColumn)

  receiveSortable: (event, ui) ->
    if !$(this).attr('class').match('droppable-column')
      $(ui.sender).sortable("cancel")
    $('.droppable-column').removeClass('droppable-column')
