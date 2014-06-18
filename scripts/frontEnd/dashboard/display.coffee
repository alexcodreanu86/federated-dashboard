namespace('Dashboard')

class Dashboard.Display
  @populateWidget: (html) ->
    $('[data-id=widget-display]').html(html)

  @generateForm: (widget) ->
    capitalized = widget[0].toUpperCase() + widget.slice(1)
    new EJS({url: 'scripts/frontEnd/dashboard/formTemplate.ejs'}).render({widget: widget, capitalized: capitalized})
