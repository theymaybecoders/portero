# Portero

Portero is another word for someone that may act as a concierge. Portero will help you find venues around a location using as many services known.

## Installation

Add this line to your application's Gemfile:

    gem 'portero'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install portero

## Usage

Configure Portero with providers, either in a Rails initializer or elsewhere:

    Portero.providers = [Portero::SearchProvider::Foursquare.new(client_id: YOUR_ID, client_secret: YOUR_SECRET)]
    Portero.init!

If more than one provider is given, it will search both providers and return combined results.

To search

    results = Portero.search("pizza", latitude, longitude, options)
    results #=> Array of Portero::SearchResult

Options can be anything the provider allows. All providers may not utilize all options. It's provider implementation dependant

SearchResult objects contain the following fields

    id
    name
    address
    latitude
    longitude
    city
    state
    postal_code
    country
    category
    icon
    extra

A provider may put whatever extraneous data that might be important in extra. It is also not forced to provide usable data in all fields.

## Writing a provider

A new provider must include Porter::SearchProvider and implement (at minimum) the search method that returns the SearchResult objects. A provider my require specific options that need to be passed to the constructor with requires_option. If those options are not given, an exception is raised. See one of the bundled providers in lib/portero/providers for examples.

## TODO

1. When using multiple providers, parallelize the requests.
2. When using multiple providers, analyze the result set and remove duplication as much as possible.
3. Always make it better

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
