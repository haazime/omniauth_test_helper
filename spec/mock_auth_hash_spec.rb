require 'spec_helper'

RSpec.describe 'mock_auth_hash' do
  before do
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
end
