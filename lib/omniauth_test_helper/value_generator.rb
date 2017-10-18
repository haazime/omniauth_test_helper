module OmniAuthTestHelper
  class ValueGenerator

    def initialize
      @generators = {}
      yield(self)
    end

    def for(key, &block)
      @generators[key.to_sym] = block
    end

    def generate
      keys.each_with_object({}) do |key, hash|
        hash[key] = generate_for_key(key, hash)
      end
    end

    private

      def keys
        @generators.keys
      end

      def generate_for_key(key, intermediate)
        @generators[key].call(intermediate)
      end
  end
end
