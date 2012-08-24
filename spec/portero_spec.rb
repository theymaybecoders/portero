require 'spec_helper'

describe Portero do

  before do
    Portero.init!
  end

  it 'should allow setting of providers' do
    foursquare_provider = Portero::SearchProvider::Foursquare.new(client_id: 1, client_secret: 1)
    google_places_provider = Portero::SearchProvider::GooglePlaces.new(key: 1)
    Portero.providers = [foursquare_provider]
    Portero.providers.should == [foursquare_provider]
    Portero.providers += [google_places_provider]
    Portero.providers.should == [foursquare_provider, google_places_provider]
  end

  it 'should search registered providers' do
    foursquare_provider = Portero::SearchProvider::Foursquare.new(client_id: 1, client_secret: 1)
    google_places_provider = Portero::SearchProvider::GooglePlaces.new(key: 1)
    Portero.providers = [foursquare_provider, google_places_provider]
    Portero.search("pizza", 38.585287, -90.40936, radius: 1000, limit: 50)
  end
end