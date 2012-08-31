require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Portero::SearchProvider::Foursquare do

  it 'should require client_id and client_secret options' do
    Portero::SearchProvider::Foursquare.required_options.should == [:client_id, :client_secret]
  end

  describe 'search results' do

    before(:each) do
      @conn = Faraday.new do |builder|
        builder.adapter Faraday.default_adapter
      end
      @provider = Portero::SearchProvider::Foursquare.new(client_id: 1, client_secret: 1)
      @results = @provider.search(@conn, "pizza", 38.585287, -90.40936, radius: 1000, limit: 50)
    end

    it 'should return search results when queried' do
      @results.should_not be_empty
    end

    it 'should return an array of SearchResults' do
      @results.should be_a(Array)
      @results.first.should be_a(Portero::SearchResult)
    end

    it 'should return an array of SearchResults when not given a query string' do
      @results = @provider.search(@conn, nil, 38.585287, -90.40936, radius: 1000, limit: 50)
      @results.should be_a(Array)
      @results.first.should be_a(Portero::SearchResult)
      @results.first.name.should == "Global Foods Market"
    end

    describe 'individual' do

      it 'should have an id' do
        @results.first.id.should == "4ade3739f964a520fa7321e3"
      end


      it 'should have a name' do
        @results.first.name.should == "Bar Louie"
      end

      it 'should have an address' do
        @results.first.address.should == "110 S Kirkwood Rd"
      end

      it 'should have a latitude' do
        @results.first.latitude.should == 38.58033319446212
      end

      it 'should have a longitude' do
        @results.first.longitude.should == -90.40589386753355
      end

      it 'should have a city' do
        @results.first.city.should == "St. Louis"
      end

      it 'should have a state' do
        @results.first.state.should == "MO"
      end

      it 'should have a postal code' do
        @results.first.postal_code.should == "63122"
      end

      it 'should have a country' do
        @results.first.country.should == "United States"
      end

      it 'should have a category name' do
        @results.first.category.should == "Bar"
      end

      it 'should have an icon' do
        @results.first.icon.should == "https://foursquare.com/img/categories_v2/nightlife/bar_64.png"
      end

      it 'should have extra data that should be accessible via string or symbol keys' do
        @results.first.extra["categories"].first["icon"]["prefix"] == "https://foursquare.com/img/categories_v2/nightlife/bar_"
        @results.first.extra[:categories].first[:icon][:suffix] == ".png"
      end

      it 'should have extra data for categories, contact, and url' do
        @results.first.extra["categories"].present?.should be_true
        @results.first.extra["contact"].present?.should be_true
        @results.first.extra["url"].present?.should be_true
      end
    end
  end
end