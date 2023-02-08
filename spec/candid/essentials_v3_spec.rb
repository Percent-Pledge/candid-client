# frozen_string_literal: true

RSpec.describe Candid::EssentialsV3 do
  describe '#configure' do
    it 'yields the configuration' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(Candid::EssentialsV3::Configuration)
    end
  end

  describe '#configuration' do
    it 'returns the configuration' do
      expect(described_class.configuration).to be_a(Candid::EssentialsV3::Configuration)
    end

    it 'returns custom property values' do
      described_class.configure do |config|
        config.api_token = '12345'
      end

      expect(described_class.configuration.api_token).to eq('12345')
    end
  end

  describe '#search_by_term' do
    it 'returns a list of resource objects' do
      stub_request(:post, 'https://api.candid.org/essentials/v3/')
        .to_return(status: 200, body: { hits: [{ name: 'Test' }] }.to_json)

      expect(described_class.search_by_term('red cross')).to all(be_a(Candid::Shared::Resource))
    end
  end
end
