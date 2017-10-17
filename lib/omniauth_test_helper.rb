require 'omniauth_test_helper/version'

require 'active_support'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/module'
require 'securerandom'

module OmniAuthTestHelper
  mattr_accessor :default_options

  INFO_KEYS = %i(name email nickname first_name last_name location description image phone urls).freeze

  def mock_auth_hash(an_args = {})
    args = an_args.deep_symbolize_keys
    auth_hash = {
      provider: detect_provider(args),
      uid: detect_uid(args),
      info: detect_info(args)
    }
    auth_hash.deep_stringify_keys
  end

  private

    def detect_provider(args)
      (args[:provider] || OmniAuthTestHelper.default_options[:provider]).to_s
    end

    def detect_uid(args)
      (args[:uid] || SecureRandom.uuid).to_s
    end

    def detect_info(args)
      args.slice(*INFO_KEYS)
        .merge(name: args[:name].to_s)
        .merge(args[:info] || {})
    end
end
