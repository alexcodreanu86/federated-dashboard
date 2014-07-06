namespace('Dashboard.Sidenav')

class Dashboard.Sidenav.Display
  @setButtonActive: (widgetWrapper) ->
    button = "[data-id=#{widgetWrapper.name}-widget]"
    $(button).parent().removeClass('inactive')
    $(button).parent().addClass('active')

  @setButtonInactive: (widgetWrapper) ->
    button = "[data-id=#{widgetWrapper.name}-widget]"
    $(button).parent().removeClass('active')
    $(button).parent().addClass('inactive')
