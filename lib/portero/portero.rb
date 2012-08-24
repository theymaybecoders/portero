require 'portero/search_provider'
require 'portero/search_result'
require 'faraday'
require 'json'

module Portero
  module SearchProvider
    autoload :Foursquare, 'portero/providers/foursquare'
    autoload :GooglePlaces, 'portero/providers/google_places'
  end

  def self.init!
    @conn = Faraday.new do |builder|
      builder.adapter Faraday.default_adapter
    end
  end

  def self.search(query, latitude, longitude, options = {})
    results = []
    @providers.each do |provider|
      results += provider.search(@conn, query, latitude, longitude, options)
    end
    results
  end

  def self.providers=(providers)
    @providers = providers
  end

  def self.providers
    @providers
  end
end