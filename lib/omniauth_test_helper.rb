require 'omniauth_test_helper/version'

require 'active_support'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/module'
require 'securerandom'

module OmniAuthTestHelper
  mattr_accessor :default_options
  
  def mock_auth_hash(attributes = {})
    auth_hash = {
      provider: attributes[:provider] || OmniAuthTestHelper.default_options[:provider].to_s,
      uid: attributes[:uid] || SecureRandom.uuid,
      info: {
        name: attributes[:name].to_s
      }
    }
    auth_hash.deep_stringify_keys
  end
end
