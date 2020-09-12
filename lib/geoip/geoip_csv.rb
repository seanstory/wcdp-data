# frozen_string_literal: true
require 'awesome_print'
require 'csv'
require_relative 'client'

module GeoIP
  class Main
    attr_reader :client

    def initialize
      @client = GeoIP::Client.build_client!
    end


    def main(input_path, output_path)
      csv = CSV.new(File.new(input_path))
      rows = csv.read[1..-1] # skip the header
      CSV.open(output_path, 'wb') do |output_csv|
        output_csv << ['VANID', 'latitude', 'longitude']
        rows.each do |row|
          # row = row[0..4] # vanid, address, city, state, zip
          latlong = nil
          begin
            latlong = client.get_lat_long(row[1], row[2], row[3], row[4])
          rescue => e
            puts "Skipping #{row[0]}: #{e.message}"
            next
          end
          output_csv << [row[0], latlong[:lat], latlong[:long]]
        end
      end
    end
  end
end

if ARGV.size == 2
  GeoIP::Main.new.main(ARGV[0], ARGV[1])
else
  puts "ERROR: Usage: `$ ruby geoip_csv.rb <input.csv> <output.csv>`"
end
