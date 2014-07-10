namespace('Dashboard.Widgets')

class Dashboard.Widgets.Templates
  @generateClosingButton: (dataName) ->
    "<button class='close-widget' data-name='#{dataName}'>X</button>"

  @generateHandle: (dataName) ->
    #TODO SWITCH WITH REAL HANDLE
    "<p class='widget-handle' data-name=#{dataName}>Handle</p>"

