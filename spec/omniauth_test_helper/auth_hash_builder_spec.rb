require 'spec_helper'

RSpec.describe OmniAuthTestHelper::AuthHashBuilder do
  it do
    auth_hash = described_class.build
    expect(auth_hash).to eq({})
  end

  it do
    auth_hash = described_class.build(
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
    auth_hash = described_class.build(
      info: { name: 'Resource Owner' }
    )
    expect(auth_hash['info']['name']).to eq('Resource Owner')
  end

  it do
    auth_hash = described_class.build(
      name: 'override me',
      info: { name: 'Resource Owner' }
    )
    aggregate_failures do
      expect(auth_hash['info']['name']).to eq('Resource Owner')
    end
  end

  it do
    auth_hash = described_class.build(
      name: 'Resource Owner',
      email: 'resource.owner@gmail.com',
      nickname: 'R.O',
      first_name: 'Resource',
      last_name: 'Owner',
      location: 'Japan',
      description: 'A Smart Guy',
      image: 'http://the.users.image/size/50x50.jpg',
      phone: '0123456789',
      urls: {
        Blog: 'http://the.blog/user'
      }
    )
    aggregate_failures do
      expect(auth_hash['info']['name']).to eq('Resource Owner')
      expect(auth_hash['info']['email']).to eq('resource.owner@gmail.com')
      expect(auth_hash['info']['nickname']).to eq('R.O')
      expect(auth_hash['info']['first_name']).to eq('Resource')
      expect(auth_hash['info']['last_name']).to eq('Owner')
      expect(auth_hash['info']['location']).to eq('Japan')
      expect(auth_hash['info']['description']).to eq('A Smart Guy')
      expect(auth_hash['info']['image']).to eq('http://the.users.image/size/50x50.jpg')
      expect(auth_hash['info']['phone']).to eq('0123456789')
      expect(auth_hash['info']['urls']['Blog']).to eq('http://the.blog/user')
    end
  end

  it do
    auth_hash = described_class.build(
      extra: {
        raw_info: {
          locale: 'ja_JP'
        }
      }
    )
    expect(auth_hash['extra']['raw_info']['locale']).to eq('ja_JP')
  end

  it do
    auth_hash = described_class.build(
      provider: 'facebook',
      info: { email: 'user@gmail.com' },
      gender: 'male',
      extra: {
        raw_info: {
          locale: 'ja_JP'
        }
      }
    )
    aggregate_failures do
      expect(auth_hash['extra']['raw_info']['provider']).to be_nil
      expect(auth_hash['extra']['raw_info']['info']).to be_nil
      expect(auth_hash['extra']['raw_info']['gender']).to eq('male')
      expect(auth_hash['extra']['raw_info']['locale']).to eq('ja_JP')
    end
  end
end
