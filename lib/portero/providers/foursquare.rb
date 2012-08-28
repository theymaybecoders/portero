module Portero
  module SearchProvider
    class Foursquare
      include SearchProvider

      requires_option :client_id
      requires_option :client_secret

      def search(conn, query, latitude, longitude, options = {})
        params = {}
        params[:query] = query if query
        params[:client_id] = @provider_options[:client_id]
        params[:client_secret] = @provider_options[:client_secret]
        params[:ll] = [latitude, longitude].join(",")
        params[:v] = "20120709"
        params[:limit] = options[:limit] || 50
        params[:radius] = options[:radius] || 10000
        results = conn.get("https://api.foursquare.com/v2/venues/search", params)
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
          venue.category = found_venue["categories"].first["name"] if found_venue["categories"].first
          venue.icon = found_venue["categories"].first["icon"]["prefix"] + "64" + found_venue["categories"].first["icon"]["suffix"] if found_venue["categories"].first
          venue.extra = {categories: found_venue["categories"], url: found_venue["url"]}

          results << venue
        end
        results
      end
    end
  end
end
