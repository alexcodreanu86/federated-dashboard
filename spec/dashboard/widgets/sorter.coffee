setupDashboardFixtures = ->
  setFixtures """
    <img data-id="menu-button">
    <div data-id="side-nav"></div>
    <div data-id="widget-display">
      <div class="widget-col" data-id='col0-container'><ul class='widget-list' data-id="col0"></ul></div>
      <div class="widget-col" data-id='col1-container'><ul class='widget-list' data-id="col1"></ul></div>
      <div class="widget-col" data-id='col2-container'><ul class='widget-list' data-id="col2"></ul></div>
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


describe 'Dashboard.Widgets.Sorter', ->
  describe 'setupSortable', ->
    it 'setupSortable is setting the columns sortable', ->
      setupDashboardFixtures()
      Dashboard.Widgets.Sorter.setupSortable()
      expect($('.widget-list')).toBeMatchedBy('.ui-sortable')

    it 'setupSortable is calling the startSorting when draging begins', ->
      setupDashboardFixtures()
      Dashboard.Widgets.Manager.generateWrappers()
      Dashboard.Widgets.Manager.setupWidget('pictures')
      Dashboard.Widgets.Sorter.setupSortable()
      spy = spyOn Dashboard.Widgets.Sorter, 'startSorting'
      $('.widget-header').simulate('drag', {dy: 50})
      expect(spy).toHaveBeenCalled()

    it 'setupSortable is calling disableDroppableColumns when draging ends', ->
      setupDashboardFixtures()
      Dashboard.Widgets.Manager.generateWrappers()
      Dashboard.Widgets.Manager.setupWidget('pictures')
      Dashboard.Widgets.Sorter.setupSortable()
      $('.widget-header').simulate('drag', {dy: 50})
      expect(col0()).not.toBeMatchedBy('.droppable-column')
      expect(col1()).not.toBeMatchedBy('.droppable-column')
      expect(col2()).not.toBeMatchedBy('.droppable-column')

  it 'disableSortable is disabling the sortable feature', ->
    setupDashboardFixtures()
    Dashboard.Widgets.Sorter.setupSortable()
    Dashboard.Widgets.Sorter.disableSortable()
    expect($('.widget-list')).toBeMatchedBy('.ui-sortable-disabled')

  it 'startSorting is adding droppable-column class to the columns that can fit the dragged item', ->
    setupDashboardFixtures()
    populateColumn('col0')
    Dashboard.Widgets.Sorter.startSorting("event", mockUi(), sender())
    expect(col0()).not.toBeMatchedBy('.droppable-column')
    expect(col1()).toBeMatchedBy('.droppable-column')
    expect(col2()).toBeMatchedBy('.droppable-column')

  it 'receiveSortable is removing the droppable-column class from all columns', ->
    setupDashboardFixtures()
    populateColumn('col0')
    Dashboard.Widgets.Sorter.setupSortable()
    Dashboard.Widgets.Sorter.startSorting("event", mockUi(), sender())
    Dashboard.Widgets.Sorter.receiveSortable('event', mockUi(), sender())
    expect(col0()).not.toBeMatchedBy('.droppable-column')
    expect(col1()).not.toBeMatchedBy('.droppable-column')
    expect(col2()).not.toBeMatchedBy('.droppable-column')
