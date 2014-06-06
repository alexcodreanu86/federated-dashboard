namespace('Pictures')

class Pictures.API
  @search: (searchString, callback)->
    flickr =  new Flickr(
      api_key: "a48194703ae0d0d1055d6ded6c4c9869"
    )
    flickr.photos.search({
        text: searchString,
        per_page: 6,
        extras: "url_n"
      }, (err, response) ->
        if err
          throw new Error(err)
        callback(response.photos.photo)
    )

