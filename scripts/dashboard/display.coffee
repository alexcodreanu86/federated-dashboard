namespace('Dashboard')

class Dashboard.Display
  @showSidenav: (buttons) ->
    contentHtml = new EJS({url: 'scripts/dashboard/sidenav/sidenavContent.ejs'}).render({buttons: buttons})
    $('[data-id=side-nav]').html(contentHtml)

  @removeSidenav: ->
    $('[data-id=side-nav]').empty()

  @isSidenavDisplayed: ->
    $('[data-id=side-nav]').html().length > 0
