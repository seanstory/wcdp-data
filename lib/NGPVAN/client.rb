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
      get_request "#{BASE_URL}/apiKeyProfiles"
    end

    def get_person_by_id(id)
      get_request"#{BASE_URL}/people/#{id}"
    end

    def get_cell_status_options
      get_request "#{BASE_URL}/phones/isCellStatuses"
    end

    def update_person(person)
      response = post("#{BASE_URL}/people/#{person.vanId}", JSON.dump(person), headers)
      match_response = Hashie::Mash.new(JSON.parse(response.body))
      unless match_response.status == 'Matched'
        raise StandardError("Failed to update #{person.vanId}. Response was: #{match_response.to_h}")
      end
    end

    def get_request(url)
      response = get(url, nil, headers)
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
