require 'active_support/core_ext/module'
require 'faraday'
require 'hashie'
require 'json'

module NGPVAN
  class Client
    BASE_URL = 'https://api.securevan.com/v4'

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

    def get_api_key_profiles
      response = get("#{BASE_URL}#{'/apiKeyProfiles'}", nil, headers)
      Hashie::Mash.new(JSON.parse(response.body))
    end

    private

    def initialize_http_client!
      @http_client = Faraday.new(BASE_URL) do |faraday|
        faraday.use Faraday::Request::BasicAuthentication, ENV['NGPVAN_APPLICATION_NAME'], "#{ENV['NGPVAN_API_KEY']}|#{ENV['NGPVAN_MODE']}"
        faraday.adapter(:httpclient)
      end
    end

    def headers
      {
        'Content-Type' => 'application/json'
      }
    end

  end
end
