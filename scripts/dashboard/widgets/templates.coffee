namespace('Dashboard.Widgets')

class Dashboard.Widgets.Templates
  @generateClosingButton: (dataName) ->
    "<span class='widget-close' data-name='#{dataName}'>×</span>"

  @generateHandle: (dataName) ->
    #TODO SWITCH WITH REAL HANDLE
    "<p class='widget-handle' data-name=#{dataName}>Handle</p>"

