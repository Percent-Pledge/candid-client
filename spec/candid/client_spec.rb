# frozen_string_literal: true

RSpec.describe Candid::Client do
  it 'has a version number' do
    expect(Candid::Client::VERSION).not_to be nil
  end

  describe '#configure' do
    it 'yields the configuration' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(Candid::Client::Configuration)
    end
  end

  describe '#configuration' do
    it 'returns the configuration' do
      expect(described_class.configuration).to be_a(Candid::Client::Configuration)
    end

    it 'returns custom property values' do
      described_class.configure do |config|
        config.api_token = '12345'
      end

      expect(described_class.configuration.api_token).to eq('12345')
    end
  end
end
