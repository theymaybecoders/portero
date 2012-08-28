module Portero
  module SearchProvider

    class GooglePlaces
      include SearchProvider

      requires_option :key

      def search(conn, query, latitude, longitude, options = {})
        params = {}
        params[:query] = query if query
        params[:key] = @provider_options[:key]
        params[:radius] = options[:radius] || 10000
        params[:location] = [latitude, longitude].join(",")
        params[:sensor] = false

        url = query.present? ? "https://maps.googleapis.com/maps/api/place/textsearch/json" : "https://maps.googleapis.com/maps/api/place/search/json"
        results = conn.get(url, params)
        parse_results(results)
      end

      def parse_results(results)
        json = JSON.parse(results.body)
        venues = json["results"]
        results = []
        venues.each do |found_venue|
          venue = Portero::SearchResult.new
          venue.id = found_venue["id"]
          venue.name = found_venue["name"]
          venue.address = found_venue["formatted_address"] || found_venue["vicinity"]
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