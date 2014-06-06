describe "Pictures.Controller", ->
  beforeEach ->
    setupPicturesFixtures()
    Pictures.Controller.bind()

  it "bind gets pictures and displays them", ->
    inputInto('flickr-search', 'bikes')
    $('[data-id=flickr-button]').click()
    expect($('img').length).toEqual(6)
