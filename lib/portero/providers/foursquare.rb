module Portero
  module SearchProvider
    class Foursquare
      include SearchProvider

      requires_option :client_id
      requires_option :client_secret

      def search(conn, query, latitude, longitude, options = {})
        results = conn.get("https://api.foursquare.com/v2/venues/search", {query: query, client_id: @provider_options[:client_id], client_secret: @provider_options[:client_secret], v: "20120709",
          limit: options[:limit], radius: options[:radius], ll: [latitude, longitude].join(",")})
        parse_results(results)
      end

      def parse_results(results)
        json = JSON.parse(results.body)
        venues = json["response"]["venues"]
        results = []
        venues.each do |found_venue|
          venue = Portero::SearchResult.new
          venue.id = found_venue["id"]
          venue.name = found_venue["name"]
          venue.address = found_venue["location"]["address"]
          venue.latitude = found_venue["location"]["lat"]
          venue.longitude = found_venue["location"]["lng"]
          venue.city = found_venue["location"]["city"]
          venue.state = found_venue["location"]["state"]
          venue.postal_code = found_venue["location"]["postalCode"]
          venue.country = found_venue["location"]["country"]
          venue.category = found_venue["categories"].first["name"]
          venue.icon = found_venue["categories"].first["icon"]["prefix"] + "64" + found_venue["categories"].first["icon"]["suffix"]
          venue.extra = {categories: found_venue["categories"], url: found_venue["url"]}

          results << venue
        end
        results
      end
    end
  end
end
