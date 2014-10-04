setupDashboardFixtures = ->
  setFixtures """
    <img data-id="menu-button">
    <div data-id="side-nav"></div>
    <div data-id="widget-display">
      <div class="widget-col" data-id='col0-container'><ul data-name="sortable-list" data-id="col0"></ul></div>
      <div class="widget-col" data-id='col1-container'><ul data-name="sortable-list" data-id="col1"></ul></div>
      <div class="widget-col" data-id='col2-container'><ul data-name="sortable-list" data-id="col2"></ul></div>
    </div>
  """

mockUi = ->
  data = {}
  data.item = $('#moving-from-col0')
  data

sender = ->
  $('[data-id=col0]')

populateColumn = (column) ->
  $("[data-id=#{column}]").append("<li id='moving-from-#{column}'  data-size='3'></li>")

col0 = ->
  getCol 'col0'

col1 = ->
  getCol 'col1'

col2 = ->
  getCol 'col2'

getCol = (column) ->
  $("[data-id=#{column}]")

newWidgetManager = ->
  new Dashboard.Widgets.Manager

newSorter = (sortableList, handle) ->
  new Dashboard.Widgets.Sorter(sortableList, handle)

sortableSelector = "[data-name=sortable-list]"
handle = "[data-name=sortable-handle]"

describe 'Dashboard.Widgets.Sorter', ->
  describe 'setupSortable', ->
    it 'sets the columns sortable', ->
      setupDashboardFixtures()
      newSorter(sortableSelector).setupSortable()
      expect($(sortableSelector)).toBeMatchedBy('.ui-sortable')

    it 'calls the startSorting when draging begins', ->
      setupDashboardFixtures()
      manager = newWidgetManager()
      manager.generateWrappers()
      manager.setupWidget('pictures')
      sorter = newSorter(sortableSelector, handle)
      sorter.setupSortable()
      spy = spyOn(Dashboard.Widgets.Display, 'showAvailableColumns')
      $(handle).simulate('drag', {dy: 50})
      expect(spy).toHaveBeenCalled()

  it 'disableDroppableColumns removes class droppable-column of the columns', ->
    setupDashboardFixtures()
    manager = newWidgetManager()
    manager.generateWrappers()
    manager.setupWidget('pictures')
    sorter = newSorter()
    sorter.setupSortable()
    $(handle).simulate('drag', {dy: 50})
    expect(col0()).not.toBeMatchedBy('.droppable-column')
    expect(col1()).not.toBeMatchedBy('.droppable-column')
    expect(col2()).not.toBeMatchedBy('.droppable-column')

  it 'disableSortable disables the sortable feature', ->
    setupDashboardFixtures()
    sorter = newSorter(sortableSelector)
    sorter.setupSortable()
    sorter.disableSortable()
    expect($(sortableSelector)).toBeMatchedBy('.ui-sortable-disabled')
