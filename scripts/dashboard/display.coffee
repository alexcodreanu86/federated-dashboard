namespace('Dashboard')

class Dashboard.Display
  @populateWidget: (html) ->
    $('[data-id=widget-display]').html(html)

  @generateForm: (widget) ->
    capitalized = widget[0].toUpperCase() + widget.slice(1)
    new EJS({url: 'scripts/dashboard/templates/form.ejs'}).render({widget: widget, capitalized: capitalized})

  @showSidenav: (buttons) ->
    contentHtml = new EJS({url: 'scripts/dashboard/templates/sidenavContent.ejs'}).render({buttons: buttons})
    $('[data-id=side-nav]').html(contentHtml)

  @removeSidenav: ->
    $('[data-id=side-nav]').empty()

  @isSidenavDisplayed: ->
    $('[data-id=side-nav]').html().length > 0
