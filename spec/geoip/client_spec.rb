# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/geoip/client'

describe 'GeoIP::Client' do

  subject { GeoIP::Client.build_client! }

  it 'can lookup an address' do
    result = subject.get_lat_long('1122 Moores Ct', 'Brentwood', 'TN', '37027')
    expect(result).to eq({ :lat => 35.9647, :long => -86.82905 })
  end
end
