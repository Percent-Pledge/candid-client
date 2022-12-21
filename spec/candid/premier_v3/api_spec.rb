# frozen_string_literal: true

RSpec.describe Candid::PremierV3::API do
  before do
    Candid::PremierV3.configure do |config|
      config.api_token = 'letmein'
    end
  end

  describe 'class methods' do
    it 'sets the base_uri' do
      expect(described_class.base_uri).to eq('https://api.candid.org/premier/v3')
    end

    it 'set the format to JSON' do
      expect(described_class.format).to eq(:json)
    end
  end

  describe '#initialize' do
    it 'sets default headers' do
      described_class.new('letmein')

      headers = described_class.default_options[:headers]

      expect(headers['Subscription-Key']).to eq('letmein')
      expect(headers['Content-Type']).to eq('application/json')
    end
  end

  describe '#lookup_by_ein' do
    let(:api) { described_class.new('letmein') }

    context 'when the response is successful' do
      before do
        stub_request(:get, 'https://api.candid.org/premier/v3/12-3456789')
          .with(headers: {
            'Content-Type' => 'application/json',
            'Subscription-Key' => 'letmein'
          })
          .to_return(status: 200, body: { data: { name: 'Test' } }.to_json)
      end

      it 'returns an API resource object' do
        expect(api.lookup_by_ein('12-3456789')).to be_a(Candid::PremierV3::Resource)
      end

      it 'allows data JSON to be traversed like an object' do
        expect(api.lookup_by_ein('12-3456789').name).to eq('Test')
      end
    end

    context 'when the response is not successful' do
      before do
        stub_request(:get, 'https://api.candid.org/premier/v3/12-3456789')
          .with(headers: {
            'Content-Type' => 'application/json',
            'Subscription-Key' => 'letmein'
          })
          .to_return(status: 404, body: { message: 'Not Found' }.to_json)
      end

      it 'raises an APIError' do
        expect { api.lookup_by_ein('12-3456789') }.to raise_error(Candid::PremierV3::API::APIError)
      end

      it 'sets the message on the error' do
        api.lookup_by_ein('12-3456789')
      rescue Candid::PremierV3::API::APIError => e
        expect(e.message).to eq('Not Found')
      end

      it 'sets the response on the error' do
        api.lookup_by_ein('12-3456789')
      rescue Candid::PremierV3::API::APIError => e
        expect(e.response).to be_a(HTTParty::Response)
      end
    end
  end
end
