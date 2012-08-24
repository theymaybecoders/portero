require 'fakeweb'

FakeWeb.allow_net_connect = false

FakeWeb.register_uri(:get, "https://api.foursquare.com/v2/venues/search?query=pizza&client_id=1&client_secret=1&limit=50&radius=1000&v=20120709&ll=38.585287%2C-90.40936", body: File.read(File.join(File.dirname(__FILE__), '..', 'data', 'foursquare.json')))
FakeWeb.register_uri(:get, "https://maps.googleapis.com/maps/api/place/textsearch/json?query=pizza&key=1&radius=1000&location=38.585287%2C-90.40936&sensor=false", body: File.read(File.join(File.dirname(__FILE__), '..', 'data', 'google_places.json')))