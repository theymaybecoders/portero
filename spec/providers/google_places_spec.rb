require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Portero::SearchProvider::GooglePlaces do

  it 'should require a key option' do
    Portero::SearchProvider::GooglePlaces.required_options.should == [:key]
  end


  describe 'search results' do

    before(:each) do
      @conn = Faraday.new do |builder|
        builder.adapter Faraday.default_adapter
      end
      @provider = Portero::SearchProvider::GooglePlaces.new(key: 1)
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
      @results.first.address.should == "Kirkwood"
    end


    describe 'individual' do

      it 'should have an id' do
        @results.first.id.should == "d5e15c83a543424975a17a7e801f2fc3e2ac9151"
      end

      it 'should have a name' do
        @results.first.name.should == "Dewey's Pizza"
      end

      it 'should have an address' do
        @results.first.address.should == "124 North Kirkwood Road, St. Louis, MO, United States"
      end

      it 'should have a latitude' do
        @results.first.latitude.should == 38.5821480
      end

      it 'should have a longitude' do
        @results.first.longitude.should == -90.406170
      end

      # it 'should have a city' do
      #    @results.first.city.should == "St. Louis"
      # end

      # it 'should have a state' do
      #    @results.first.state.should == "MO"
      # end

      # it 'should have a postal code' do
      #   @results.first.postal_code.should == "63122"
      # end

      # it 'should have a country' do
      #   @results.first.country.should == "United States"
      # end

      it 'should have a category name' do
        @results.first.category.should == "restaurant"
      end


      it 'should have an icon' do
        @results.first.icon.should == "http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png"
      end

    end
  end



end