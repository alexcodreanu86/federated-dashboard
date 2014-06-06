describe "Pictures.Display", ->

  beforeEach ->
    setupPicturesFixtures()

  it "getInput returns the flick-search field", ->
    inputInto('flickr-search', "123")
    expect(Pictures.Display.getInput()).toEqual("123")

  it "addImages displays the images on the screen", ->
    images =  [{url_n: "url1.jpeg"}, {url_n: "url2.jpeg"}, {url_n: "url3.jpeg"}, {url_n: "url4.jpeg"}, {url_n: "url5.jpeg"}, {url_n: "url6.jpeg"}]
    Pictures.Display.addImages(images)
    expect($('img').length).toEqual(6)


