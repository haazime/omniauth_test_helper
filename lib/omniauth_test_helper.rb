require 'omniauth_test_helper/version'

require 'active_support'
require 'active_support/core_ext/hash'
require 'securerandom'

module OmniAuthTestHelper
  
  def mock_auth_hash(attributes = {})
    auth_hash = {
      provider: attributes[:provider],
      uid: attributes[:uid] || SecureRandom.uuid,
      info: {
        name: attributes[:name]
      }
    }
    auth_hash.deep_stringify_keys
  end
end
