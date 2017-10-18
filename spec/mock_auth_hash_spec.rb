require 'spec_helper'

RSpec.describe 'mock_auth_hash' do
  before do
    RSpec.configure do |c|
      c.include OmniAuthTestHelper
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
