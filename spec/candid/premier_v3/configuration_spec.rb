# frozen_string_literal: true

RSpec.describe Candid::PremierV3::Configuration do
  describe '#api_token' do
    it 'returns the API token' do
      config = described_class.new
      config.api_token = '12345'

      expect(config.api_token).to eq('12345')
    end

    it 'raises if API token is not set' do
      expect { described_class.new.api_token }.to raise_error(ArgumentError, 'Candid Premier V3 api_token must be set')
    end
  end
end
