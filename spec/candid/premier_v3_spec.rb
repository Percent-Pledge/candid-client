# frozen_string_literal: true

RSpec.describe Candid::PremierV3 do
  describe '#configure' do
    it 'yields the configuration' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(Candid::PremierV3::Configuration)
    end
  end

  describe '#configuration' do
    it 'returns the configuration' do
      expect(described_class.configuration).to be_a(Candid::PremierV3::Configuration)
    end

    it 'returns custom property values' do
      described_class.configure do |config|
        config.api_token = '12345'
      end

      expect(described_class.configuration.api_token).to eq('12345')
    end
  end

  describe '#lookup_by_ein' do
    it 'returns a resource object' do
      stub_request(:get, 'https://api.candid.org/premier/v3/12345')
        .to_return(status: 200, body: { data: { name: 'Test' } }.to_json)

      expect(described_class.lookup_by_ein('12345')).to be_a(Candid::PremierV3::Resource)
    end
  end
end
