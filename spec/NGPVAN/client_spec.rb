require 'rspec'
require 'webmock/rspec'
require_relative '../../lib/NGPVAN/client'
include WebMock::API

describe NGPVAN::Client do

  subject { NGPVAN::Client.build_client! }

  it '#get_api_key_profiles' do
    stub_request(:get, NGPVAN::Client::BASE_URL+"/apiKeyProfiles").to_return(:status => 200, :body => fixture_from('api_key_profiles'))
    expect(subject.get_api_key_profiles.items[0].apiKeyTypeName).to eq('Dev Portal')
  end

  def fixture_from(fixture_name)
    File.read(File.join('spec/fixtures/NGPVAN', "#{fixture_name}.json"), :encoding => 'utf-8')
  end
end
