describe "Dashboard.Widgets.Templates" , ->
  it "generateClosingButton returns a closing button", ->
    button = Dashboard.Widgets.Templates.generateClosingButton('pictures')
    expect(button).toBeMatchedBy('[data-name=pictures].close-widget')

  it "generateHandle returns a propper handle", ->
    handle = Dashboard.Widgets.Templates.generateHandle('pictures')
    expect(handle).toBeMatchedBy('[data-name=pictures].widget-handle')
