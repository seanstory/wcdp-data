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

  it '#get_person_by_id' do
    stub_request(:get, NGPVAN::Client::BASE_URL+"/people/1").to_return(:status => 200, :body => fixture_from('person_1'))
    person = subject.get_person_by_id(1)
    expect(person.vanId).to be(1)
    expect(person.firstName).to eq('Terry')
    expect(person.phones).to be_nil

    stub_request(:get, NGPVAN::Client::BASE_URL+"/people/215501").to_return(:status => 200, :body => fixture_from('person_215501'))
    person = subject.get_person_by_id(215501)
    expect(person.vanId).to be(215501)
    expect(person.firstName).to eq('James')
    expect(person.phones.size).to be(2)
  end

  xit '#update_person' do
    # TODO
  end


  def fixture_from(fixture_name)
    File.read(File.join('spec/fixtures/NGPVAN', "#{fixture_name}.json"), :encoding => 'utf-8')
  end
end
