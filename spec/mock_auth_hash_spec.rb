require 'spec_helper'

RSpec.describe 'mock_auth_hash' do
  before do
    OmniAuthTestHelper.default_options = {
      provider: :twitter
    }
    RSpec.configure do |c|
      c.include OmniAuthTestHelper
    end
  end

  it do
    auth_hash =
      mock_auth_hash(
        provider: 'google_oauth2',
        uid: 'uid123',
        name: 'Resource Owner'
      )

    aggregate_failures do
      expect(auth_hash['provider']).to eq('google_oauth2')
      expect(auth_hash['uid']).to eq('uid123')
      expect(auth_hash['info']['name']).to eq('Resource Owner')
    end
  end

  it do
    auth_hash =
      mock_auth_hash(
        provider: :google_oauth2,
        uid: :uid123,
        name: :Resource_Owner
      )

    aggregate_failures do
      expect(auth_hash['provider']).to eq('google_oauth2')
      expect(auth_hash['uid']).to eq('uid123')
      expect(auth_hash['info']['name']).to eq('Resource_Owner')
    end
  end

  it do
    auth_hash =
      mock_auth_hash(
        provider: 'google_oauth2',
        name: 'Resource Owner'
      )
    uid = auth_hash['uid']

    aggregate_failures do
      expect(uid).to_not be_nil
      expect(uid).to be_instance_of(String)
      expect(uid.size).to be > 1
    end
  end

  it do
    OmniAuthTestHelper.default_options = {
      provider: :facebook
    }
    auth_hash =
      mock_auth_hash(
        name: 'Resource Owner'
      )
    provider = auth_hash['provider']

    expect(provider).to eq('facebook')
  end
end
