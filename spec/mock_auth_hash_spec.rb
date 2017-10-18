require 'spec_helper'

RSpec.describe 'mock_auth_hash' do
  before do
    RSpec.configure do |c|
      c.include OmniAuthTestHelper
    end
  end

  it do
    OmniAuthTestHelper.register_generator do |g|
      g.for(:provider) { 'twitter' }
      g.for(:uid) { '0123456789' }
      g.for(:name) { |h| "User #{h[:uid][0, 3]}" }
      g.for(:email) { |h| "#{h[:uid]}@gmail.com" }
    end

    auth_hash = mock_auth_hash

    aggregate_failures do
      expect(auth_hash['provider']).to eq('twitter')
      expect(auth_hash['uid']).to eq('0123456789')
      expect(auth_hash['info']['name']).to eq('User 012')
      expect(auth_hash['info']['email']).to eq('0123456789@gmail.com')
    end
  end

  it do
    auth_hash = mock_auth_hash(email: 'override me') do |h|
      h['info']['email'] = 'resource.owner@gmail.com'
    end
    expect(auth_hash['info']['email']).to eq('resource.owner@gmail.com')
  end

  it do
    name_suffix = 'from OAuth'
    OmniAuthTestHelper.register_generator do |g|
      g.for(:name) do
        "User #{name_suffix}"
      end
      g.for(:email) do
        "override@gmail.com"
      end
    end
    auth_hash = mock_auth_hash(email: 'user@gmail.com')
    expect(auth_hash['info']['name']).to eq('User from OAuth')
    expect(auth_hash['info']['email']).to eq('user@gmail.com')
  end
end
