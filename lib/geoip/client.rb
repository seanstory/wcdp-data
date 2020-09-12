require 'active_support/core_ext/module'
require 'awesome_print'
require 'faraday'
require 'hashie'
require 'json'

module GeoIP
  class Client
    BASE_URL = 'https://geocoding.geo.census.gov/geocoder/locations/'

    def initialize
      @base_url = BASE_URL
    end

    def build_client!
      initialize_http_client!
      self
    end

    def self.build_client!
      Client.new.build_client!
    end

    delegate :get, :post, :put, :delete, :head, :patch, :options, :to => :@http_client

    def get_lat_long(street, city, state, zip)
      params = {
        :street => street,
        :city => city,
        :state => state,
        :zip => zip,
        :benchmark => 'Public_AR_Current',
        :format => 'json'
      }
      response = get_request('address', params)
      matches = response.dig('result', 'addressMatches')
      if matches.nil? || matches.empty?
        puts 'Response was: '
        ap response
        raise "No matching address for #{params}"
      end

      {
        :lat => matches[0]['coordinates']['y'],
        :long => matches[0]['coordinates']['x']
      }
    end

    def get_request(url, params)
      response = get(url, params, headers)
      JSON.parse(response.body)
    end

    private

    def initialize_http_client!
      @http_client = Faraday.new(BASE_URL) do |faraday|
        faraday.adapter(:httpclient)
      end
    end

    def headers
      {}
    end
  end
end
#curl 'https://geocoding.geo.census.gov/geocoder/locations/address?street=4600+Silver+Hill+Rd&city=Suitland&state=MD&zip=20746&benchmark=Public_AR_Census2010&format=json' | jq
