namespace('Dashboard.Columns')

class Dashboard.Columns.Display
  @appendContainerToColumn: (dataId, column) ->
    $("[data-id=#{column}]").append(
      "<li class='widget' data-id='#{dataId}'></li>"
    )

  @setColumnAsAvailable: (colDataId) ->
    $("[data-id=#{colDataId}-container]").addClass('droppable-column')

  @removeDroppableColumns: ->
    $('.droppable-column').removeClass('droppable-column')
    $('.ui-droppable').removeClass('ui-droppable')

