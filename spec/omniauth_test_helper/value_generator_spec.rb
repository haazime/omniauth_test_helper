require 'spec_helper'

RSpec.describe OmniAuthTestHelper::ValueGenerator do
  it do
    number = 777

    generator = 
      described_class.new do |g|
        g.for(:name) do
          "User #{number}"
        end
        g.for(:email) do
          "user.#{number}@gmail.com"
        end
      end

    values = generator.generate
    aggregate_failures do
      expect(values[:name]).to eq('User 777')
      expect(values[:email]).to eq('user.777@gmail.com')
    end
  end
end
