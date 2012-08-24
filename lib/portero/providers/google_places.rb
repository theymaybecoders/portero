module Portero
  module SearchProvider

    class GooglePlaces
      include SearchProvider

      requires_option :key

      def search(conn, query, latitude, longitude, options = {})
        results = conn.get("https://maps.googleapis.com/maps/api/place/textsearch/json", {query: query, key: @provider_options[:key],
        radius: options[:radius], location: [latitude, longitude].join(","), sensor: false})
        parse_results(results)
      end

      def parse_results(results)
        json = JSON.parse(results.body)
        venues = json["results"]
        results = []
        venues.each do |found_venue|
          venue = Portero::SearchResult.new
          venue.name = found_venue["name"]
          venue.address = found_venue["formatted_address"]
          venue.latitude = found_venue["geometry"]["location"]["lat"]
          venue.longitude = found_venue["geometry"]["location"]["lng"]
          venue.city = ""
          venue.state = ""
          venue.postal_code = ""
          venue.country = ""
          venue.category = found_venue["types"].first
          venue.icon = found_venue["icon"]
          venue.extra = {types: found_venue["types"]}

          results << venue
        end
        results
      end

    end

  end
end