namespace('Dashboard.Widgets')

class Dashboard.Widgets.Sorter
  constructor: (sortableList, handle) ->
    @sortableList = sortableList || '[data-name=sortable-list]'
    @handle       = handle       || '[data-name=sortable-handle]'

  setupSortable: ->
    $(@sortableList).sortable({
      connectWith: @sortableList,
      handle: @handle,
      start: @startSorting
      receive: @receiveSortable
      stop: -> $('.droppable-column').removeClass('droppable-column')
 
    })
    $(@sortableList).sortable('enable')

  disableSortable: ->
    $('.droppable-column').removeClass('droppable-column')
    $(@sortableList).sortable('disable')

  startSorting: (event, ui) ->
    draggedItemSize = parseInt(ui.item.attr('data-size'))
    senderColumn = $(this).attr('data-id')
    Dashboard.Widgets.Display.showAvailableColumns(draggedItemSize, senderColumn)

  receiveSortable: (event, ui) ->
    if !$(this).attr('class').match('droppable-column')
      $(ui.sender).sortable("cancel")
    $('.droppable-column').removeClass('droppable-column')
