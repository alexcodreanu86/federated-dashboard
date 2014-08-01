namespace('Dashboard')

class Dashboard.Display
  @showSidenav: (buttons) ->
    contentHtml = new EJS({url: 'scripts/dashboard/sidenav/sidenavContent.ejs'}).render({buttons: buttons})
    $('[data-id=widget-buttons]').html(contentHtml)

  @removeSidenav: ->
    $('[data-id=widget-buttons]').empty()

  @isSidenavDisplayed: ->
    $('[data-id=widget-buttons]').html().length > 0
