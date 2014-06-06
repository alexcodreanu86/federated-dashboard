namespace('Pictures')

class Pictures.Display
  @getInput: ->
    $('[name=flickr-search]').val()

  @addImages: (images) ->
    imagesHtml = new EJS({url: 'scripts/pictures/template.ejs'}).render({images: images})
    $('[data-id=flickr-images]').html(imagesHtml)
