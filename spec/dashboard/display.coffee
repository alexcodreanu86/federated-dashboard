setupDashboardFixtures = ->
  setFixtures """
            <li><button data-id="pictures-widget">Pictures</button></li>
            <li><button data-id="weather-widget">Weather</button></li>
            <li><button data-id="stock-widget">Stock</button></li>
            <div data-id="widget-display"></div>
            """
window.setupDashboardFixtures = setupDashboardFixtures

assertFormElementAreInDOM = ->
  expect($('[name=my-widget-search]')).toBeInDOM()
  expect($('[data-id=my-widget-button]')).toBeInDOM()


clickOn = (element) ->
  $(element).click()

describe 'Dashboard.Display', ->
  beforeEach ->
    setupDashboardFixtures()

  it "populateWidget adds html to the widget display container", ->
    Dashboard.Display.populateWidget('<h1>Hello world</h1>')
    expect($('[data-id=widget-display]').html()).toEqual('<h1>Hello world</h1>')

  it "generateForm returns html for the desired widget", ->
    html = Dashboard.Display.generateForm('my-widget')
    $('[data-id=widget-display]').append(html)
    assertFormElementAreInDOM()
