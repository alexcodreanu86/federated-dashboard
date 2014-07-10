setupDashboardFixtures = ->
  setFixtures """
    <div data-id="widget-display">
      <div class="widget-col" data-id='col0-container'><ul class='widget-list' data-id="col0"></ul></div>
      <div class="widget-col" data-id='col1-container'><ul class='widget-list' data-id="col1"></ul></div>
      <div class="widget-col" data-id='col2-container'><ul class='widget-list' data-id="col2"></ul></div>
    </div>
  """

describe "Dashboard.Columns.Display", ->
  it "append container to column appends the desired container to the given column", ->
    setFixtures("<div data-id='col0'></div>")
    Dashboard.Columns.Display.appendContainerToColumn('pictures', 'col0')
    expect($('[data-id=col0]')).toContainElement("[data-id=pictures].widget")

  it "setColumnAsAvailable adds available-slots class to the given list", ->
    setupDashboardFixtures()
    Dashboard.Columns.Display.setColumnAsAvailable('col0')
    expect($('[data-id=col0]').parent()).toBeMatchedBy('.droppable-column')

  it "removeDroppableColumns removes the class from droppables", ->
    setupDashboardFixtures()
    Dashboard.Columns.Display.setColumnAsAvailable('col0')
    Dashboard.Columns.Display.setColumnAsAvailable('col2')
    Dashboard.Columns.Display.removeDroppableColumns()
    expect($('[data-id=col0]').parent()).not.toBeMatchedBy('.droppable-column')
    expect($('[data-id=col2]').parent()).not.toBeMatchedBy('.droppable-column')
