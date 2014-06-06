namespace('Pictures')

class Pictures.Controller
  @loadImages: (searchStr) ->
    Pictures.API.search(searchStr, Pictures.Display.addImages)

  @bind: ->
    $('[data-id=flickr-button]').click(=> @loadImages(Pictures.Display.getInput()))


