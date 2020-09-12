# frozen_string_literal: true
require 'active_support/core_ext/module'
require 'faraday'
require 'hashie'
require 'json'

module Elasticsearch
  class Client
    BASE_URL = 'http://localhost:9200'

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

    def get_request(url)
      response = get(url, nil, headers)
      Hashie::Mash.new(JSON.parse(response.body))
    end

    def delete_index(index)
      response = delete("#{index}")
      unless response.success? || response.status == 404
        raise "Failed to delete index #{index}: #{response.body}"
      end
      JSON.parse(response.body)
    end

    def set_mapping(index, mapping)
      response = put("#{index}", mapping, headers)
      unless response.success?
        raise "Failed to set mapping for #{index}: #{response.body}"
      end
      JSON.parse(response.body)
    end

    def add(index, id, json)
      response = post("#{index}/_doc/#{id}", json, headers)
      unless response.success?
        raise "Failed to add #{id} to #{index}: #{response.body}"
      end
      JSON.parse(response.body)
    end

    private

    def initialize_http_client!
      @http_client = Faraday.new(BASE_URL) do |faraday|
        faraday.use Faraday::Request::BasicAuthentication, 'elastic', "changeme"
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


