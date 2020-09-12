# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/elasticsearch/indexer'


describe 'Elasticsearch::Indexer' do

  it 'can read ips into a map' do
    geoip_csv_path = 'spec/fixtures/elasticsearch/geoip.csv'
    expect(Elasticsearch::Indexer.geoip_map(geoip_csv_path)).to eq(
      {
        '6271' => [35.957436, -86.72896],
        '12155' => [35.9647, -86.82905],
        '12179' => [35.779125, -86.888855]
      })
  end
end
