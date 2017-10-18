require "spec_helper"

RSpec.describe OmniAuthTestHelper do
  it do
    described_class.register_generator do |g|
      g.for(:name) { 'default context' }
    end

    described_class.register_generator_on(:other) do |g|
      g.for(:name) { 'other context' }
    end

    default = described_class.generators[:default].generate
    other = described_class.generators[:other].generate

    aggregate_failures do
      expect(default).to eq(name: 'default context')
      expect(other).to eq(name: 'other context')
    end
  end
end
