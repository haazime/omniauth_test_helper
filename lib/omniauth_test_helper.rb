require 'omniauth_test_helper/version'

require 'active_support'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/module'
require 'securerandom'

module OmniAuthTestHelper
  mattr_accessor :default_options, :generators

  self.generators = {}

  INFO_KEYS = %i(name email nickname first_name last_name location description image phone urls).freeze
  INFO_KEYS_SET = Set[*(%i(provider uid) + INFO_KEYS)].freeze

  class << self
    def register_generators
      yield(self)
    end

    def generate_for(key, &block)
      self.generators[key] = block
    end
  end

  def mock_auth_hash(an_args = {})
    args = an_args.deep_symbolize_keys

    auth_hash = {
      provider: detect_provider(args),
      uid: detect_uid(args),
      info: detect_info(args),
      extra: detect_extra(args)
    }

    yield(auth_hash) if block_given?

    auth_hash.deep_stringify_keys
  end

  private

    def detect_provider(args)
      (args[:provider] || OmniAuthTestHelper.default_options[:provider]).to_s
    end

    def detect_uid(args)
      args[:uid] || SecureRandom.uuid
    end

    def detect_info(args)
      default =
        INFO_KEYS.each_with_object({}) do |k, h|
          value =
            if generator = OmniAuthTestHelper.generators[k]
              generator.call
            else
              nil
            end
          h[k] = value
        end
      default
        .merge(args.slice(*INFO_KEYS))
        .merge(args[:info] || {})
    end

    def detect_extra(args)
      extra_keys = Set[*args.keys] - INFO_KEYS_SET
      given_raw_info = args.fetch(:extra, {}).fetch(:raw_info, {})
      raw_info =
        args
          .slice(*extra_keys)
          .merge(given_raw_info)
      { raw_info: raw_info }
    end
end
