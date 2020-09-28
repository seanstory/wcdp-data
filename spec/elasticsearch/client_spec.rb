# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/elasticsearch/client'

describe 'Elasticsearch::Client' do

  subject { Elasticsearch::Client.build_client! }

  it 'forms bulk requests' do
    index = 'some_index'
    documents = ['{"foo":"bar"}', '{"foo":"baz"}']
    ndjson = subject.send(:bulk_json_from_array, index, documents)
    puts ndjson
    expect(ndjson.lines.size).to be(4)
  end
end
