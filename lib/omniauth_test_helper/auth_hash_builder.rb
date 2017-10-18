require 'set'

module OmniAuthTestHelper
  class AuthHashBuilder
    INFO_KEYS = %i(name email nickname first_name last_name location description image phone urls).freeze
    NOT_EXTRA_KEY_SET = Set[*(%i(provider uid info extra) + INFO_KEYS)].freeze

    class << self

      def build(args = {})
        new(args).build
      end
    end

    def initialize(an_args = {})
      @args = an_args.deep_symbolize_keys
    end

    def build
      {
        provider: @args[:provider].to_s,
        uid: @args[:uid],
        info: build_info,
        extra: build_extra
      }.deep_stringify_keys
    end

    private

      def build_info
        @args
          .slice(*INFO_KEYS)
          .merge(@args[:info] || {})
      end

      def build_extra
        { raw_info: build_raw_info }
      end

      def build_raw_info
        extra_keys = Set[*@args.keys] - NOT_EXTRA_KEY_SET
        given_raw_info = @args.fetch(:extra, {}).fetch(:raw_info, {})
        @args
          .slice(*extra_keys)
          .merge(given_raw_info)
      end
  end
end
