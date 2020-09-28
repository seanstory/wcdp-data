# frozen_string_literal: true

require 'rspec'
require 'json'
require_relative '../../lib/elasticsearch/converter'

describe 'Elasticsearch::Converter' do

  it 'converts to json' do
    row = ['foo', 'bar', 'baz']
    col_names = ['a', 'b','c']
    json = Elasticsearch::Converter.csv_row_to_hash(row, col_names)
    expect(json).to eq(
      {
        'a' => 'foo',
        'b' => 'bar',
        'c' => 'baz'
      })
  end

  it 'handles duplicate column names' do
    row = ['foo', 'bar', 'baz']
    col_names = ['a', 'a','a']
    json = Elasticsearch::Converter.csv_row_to_hash(row, col_names)
    expect(json).to eq(
      {
        'a' => 'foo',
        'a_2' => 'bar',
        'a_3' => 'baz'
      })
  end

end
