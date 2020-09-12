# frozen_string_literal: true
require 'csv'
require 'awesome_print'
require_relative 'client'
require_relative 'converter'

module Elasticsearch
  class Indexer
    INDEX_NAME = 'people'

    attr_reader :client

    def initialize
      @client = Elasticsearch::Client.build_client!
    end

    def index(data_csv_path, geoip_csv_path)
      client.delete_index(INDEX_NAME)
      client.set_mapping(INDEX_NAME, JSON.parse(File.new('lib/elasticsearch/people_mapping.json').read).to_json)
      geoips = self.class.geoip_map(geoip_csv_path)
      csv = CSV.new(File.new(data_csv_path))
      all_rows = csv.read
      col_names = all_rows[0]
      rows = all_rows[1..-1] # skip the header
      rows.each do |row|
        latlon = geoips[row[0]]
        data = row_to_es_json(row, col_names, latlon)
        # puts data
        puts "Adding #{row[0]} to '#{INDEX_NAME}'"
        client.add('people', row[0], data)
      end
    end

    def row_to_es_json(row, col_names, latlon)
      hsh = Elasticsearch::Converter.csv_row_to_hash(row, col_names)
      if latlon
        hsh['location'] = {
          'lat' => latlon[0],
          'lon' => latlon[1]
        }
      end
      JSON.pretty_generate(hsh)
    end


    def self.geoip_map(geoip_csv_path)
      csv = CSV.new(File.new(geoip_csv_path))
      rows = csv.read[1..-1] # skip the header
      rows.each_with_object({}) do |row, map|
        map[row[0]] = row[1..2].map(&:to_f)
      end
    end

  end
end


if ARGV.size == 2
  Elasticsearch::Indexer.new.index(ARGV[0], ARGV[1])
else
  puts "ERROR: Usage: `$ ruby indexer.rb <data.csv> <geoip.csv>`"
end
