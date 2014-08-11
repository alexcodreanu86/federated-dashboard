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
resetContainerCount = ->
  Dashboard.Widgets.Display.containerCount = 0

describe "Dashboard.Widgets.Display", ->
  beforeEach ->
    resetContainerCount()

  it 'containerCount is 0 on initialization', ->
    expect(Dashboard.Widgets.Display.containerCount).toBe(0)

  it 'incrementContainer is incrementing the widgetContainers', ->
    Dashboard.Widgets.Display.incrementContainerCount()
    expect(Dashboard.Widgets.Display.containerCount).toBe(1)

  describe 'generateContainer', ->
    it 'appends a container to col0 when all cols are empty', ->
      setupDashboardFixtures()
      Dashboard.Widgets.Display.generateContainer(3)
      expect($('[data-id=col0]')).toContainElement('[data-id=container-0]')

    it 'returns the container that it appended to the view', ->
      setupDashboardFixtures()
      container = Dashboard.Widgets.Display.generateContainer(3)
      expect(container).toEqual('[data-id=container-0]')

    it 'returns a container that has the coresponding size as data-size', ->
      setupDashboardFixtures()
      container = Dashboard.Widgets.Display.generateContainer(3)
      expect($(container)).toBeMatchedBy('[data-size=3]')

  describe 'getAvailableColumn', ->
    it 'returns col0 when there is enough space in col0', ->
      setupDashboardFixtures()
      column = Dashboard.Widgets.Display.getFirstAvailableColumn(3)
      expect(column).toEqual('col0')

    it 'returns col1 when there is enough space in col1 and not in col0', ->
      setupDashboardFixtures()
      Dashboard.Widgets.Display.generateContainer(3)
      column = Dashboard.Widgets.Display.getFirstAvailableColumn(3)
      expect(column).toEqual('col1')

    it 'returns col2 when there is space only in column 2', ->
      setupDashboardFixtures()
      Dashboard.Widgets.Display.generateContainer(3)
      Dashboard.Widgets.Display.generateContainer(3)
      column = Dashboard.Widgets.Display.getFirstAvailableColumn(3)
      expect(column).toEqual('col2')

    it 'returns null when there is no space in any column', ->
      setupDashboardFixtures()
      Dashboard.Widgets.Display.generateContainer(3)
      Dashboard.Widgets.Display.generateContainer(3)
      Dashboard.Widgets.Display.generateContainer(3)
      column = Dashboard.Widgets.Display.getFirstAvailableColumn(3)
      expect(column).toBeFalsy()

  describe 'getAllAvailableColumns', ->
    it "returns all the columns when they are all available", ->
      setupDashboardFixtures()
      columns = Dashboard.Widgets.Display.getAllAvailableColumns(3)
      expect(columns[0]).toEqual('col0')
      expect(columns[1]).toEqual('col1')
      expect(columns[2]).toEqual('col2')

    it "returns only the available columns if there are any", ->
      setupDashboardFixtures()
      Dashboard.Widgets.Display.generateContainer(3)
      columns = Dashboard.Widgets.Display.getAllAvailableColumns(3)
      expect(columns[0]).toEqual('col1')
      expect(columns[1]).toEqual('col2')

  it 'showAvailableColumns is displaying the available columns', ->
      setupDashboardFixtures()
      Dashboard.Widgets.Display.generateContainer(3)
      Dashboard.Widgets.Display.showAvailableColumns(3)
      expect($('[data-id=col0]')).not.toBeMatchedBy('.droppable-column')
      expect($('[data-id=col1]')).toBeMatchedBy('.droppable-column')
      expect($('[data-id=col2]')).toBeMatchedBy('.droppable-column')

