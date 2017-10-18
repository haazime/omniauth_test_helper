require 'set'

module OmniAuthTestHelper
  class AuthHashBuilder
    INFO_KEYS = %i(name email nickname first_name last_name location description image phone urls).freeze
    INFO_KEY_SET = Set[*INFO_KEYS].freeze
    NOT_EXTRA_KEY_SET = Set[*(%i(provider uid info extra) + INFO_KEYS)].freeze

    class << self

      def build(args = {})
        new(args).build
      end
    end

    def initialize(an_args = {})
      @args = an_args.deep_symbolize_keys
      @auth_hash = {}
    end

    def build
      build_provider
      build_uid
      build_info
      build_extra
      @auth_hash.deep_stringify_keys
    end

    private

      def build_provider
        return unless @args[:provider]
        @auth_hash[:provider] = @args[:provider]
      end

      def build_uid
        return unless @args[:uid]
        @auth_hash[:uid] = @args[:uid]
      end

      def build_info
        return if (INFO_KEY_SET & @args.keys).empty? && !@args.key?(:info)
        @auth_hash[:info] =
          @args
            .slice(*INFO_KEYS)
            .merge(@args[:info] || {})
      end

      def build_extra
        extra_keys = Set[*@args.keys] - NOT_EXTRA_KEY_SET
        return if extra_keys.empty? && !@args.key?(:extra)
        @auth_hash[:extra] = { raw_info: build_raw_info(extra_keys) }
      end

      def build_raw_info(extra_keys)
        given_raw_info = @args.fetch(:extra, {}).fetch(:raw_info, {})
        @args
          .slice(*extra_keys)
          .merge(given_raw_info)
      end
  end
end
