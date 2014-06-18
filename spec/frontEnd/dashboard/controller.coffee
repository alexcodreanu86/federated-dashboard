clickOn = (element) ->
  $(element).click()

describe "Dashboard.Controller", ->
  beforeEach ->
    setupDashboardFixtures()
    Dashboard.Controller.bind()

  it "bind displays the form for pictures when the pictures button is clicked", ->
    clickOn('[data-id=pictures-widget]')
    expect($('[data-id=pictures-button]')).toBeInDOM()

  it "bind displays the form for weather when the weather button is clicked", ->
    clickOn('[data-id=weather-widget]')
    expect($('[data-id=weather-button]')).toBeInDOM()

  it "bind displays the form for stocks when the stock button is clicked", ->
    clickOn('[data-id=stock-widget]')
    expect($('[data-id=stock-button]')).toBeInDOM()

  it "loadForm binds the widget Controller to listen for clicks", ->
    spy = spyOn(Weather.Controller, 'bind')
    Dashboard.Controller.loadForm('weather', Weather.Controller)
    expect(spy).toHaveBeenCalled()
