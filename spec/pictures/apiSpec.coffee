describe "Flickr.Parser", ->
  it "search passes the results to the callback", ->
    obj = {method: (response) ->}
    spy = spyOn(obj, 'method')
    result = Pictures.API.search("string", obj.method)
    expect(spy).toHaveBeenCalledWith([{url_n: "url1.jpeg"}, {url_n: "url2.jpeg"}, {url_n: "url3.jpeg"}, {url_n: "url4.jpeg"}, {url_n: "url5.jpeg"}, {url_n: "url6.jpeg"}])


