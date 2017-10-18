require 'active_support'
require 'active_support/core_ext/module'
require 'active_support/core_ext/hash'

require 'omniauth_test_helper/version'
require 'omniauth_test_helper/auth_hash_builder'
require 'omniauth_test_helper/value_generator'

module OmniAuthTestHelper
  mattr_accessor :generators

  self.generators = {}

  class << self
    def register_generator(&block)
      register_generator_on(:default, &block)
    end

    def register_generator_on(context, &block)
      self.generators[context.to_sym] = ValueGenerator.new(&block)
    end
  end

  def mock_auth_hash(args = {})
    default =
      if generator = OmniAuthTestHelper.generators[:default]
        AuthHashBuilder.build(generator.generate)
      else
        {}
      end

    overrides = AuthHashBuilder.build(args)

    auth_hash = default.deep_merge(overrides)

    yield(auth_hash) if block_given?
    auth_hash
  end
end
