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
handle = ".widget-header"

# TODO add data-name sortable-handle to widgets views

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
      spy = spyOn(sorter, 'startSorting')
      $(handle).simulate('drag', {dy: 50})
      expect(spy).toHaveBeenCalled()

    it 'calls disableDroppableColumns when draging ends', ->
      setupDashboardFixtures()
      manager = newWidgetManager()
      manager.generateWrappers()
      manager.setupWidget('pictures')
      newSorter().setupSortable()
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

  it 'startSorting adds droppable-column class to the columns that can fit the dragged item', ->
    setupDashboardFixtures()
    populateColumn('col0')
    newSorter(sortableSelector).startSorting("event", mockUi(), sender())
    expect(col0()).toBeMatchedBy('.droppable-column')
    expect(col1()).toBeMatchedBy('.droppable-column')
    expect(col2()).toBeMatchedBy('.droppable-column')

  it 'receiveSortable removes the droppable-column class from all columns', ->
    setupDashboardFixtures()
    populateColumn('col0')
    sorter = newSorter()
    sorter.setupSortable(sortableSelector)
    sorter.startSorting("event", mockUi(), sender())
    sorter.receiveSortable('event', mockUi(), sender())
    expect(col0()).not.toBeMatchedBy('.droppable-column')
    expect(col1()).not.toBeMatchedBy('.droppable-column')
    expect(col2()).not.toBeMatchedBy('.droppable-column')
