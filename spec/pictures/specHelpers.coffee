setupPicturesFixtures = ->
  setFixtures """
                <div id="flickr-wrapper">
                  <input name="flickr-search" type="text"><br>
                  <button data-id="flickr-button">Flicker</button>
                  <div data-id="flickr-images"></div>
                </div>
              """
inputInto = (name, value)->
  $("[name=#{name}]").val(value)

clickOn = (element) ->
  $(element).click()

class Flickr
  photos: {
            search:  (options, callback) ->
              callback(null, photos: photo: [{url_n: "url1.jpeg"}, {url_n: "url2.jpeg"}, {url_n: "url3.jpeg"}, {url_n: "url4.jpeg"}, {url_n: "url5.jpeg"}, {url_n: "url6.jpeg"}])}

window.Flickr = Flickr
window.setupPicturesFixtures = setupPicturesFixtures
window.inputInto = inputInto
window.clickOn = clickOn
