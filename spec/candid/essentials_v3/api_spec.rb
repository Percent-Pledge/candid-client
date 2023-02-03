# frozen_string_literal: true

RSpec.describe Candid::EssentialsV3::API do
  before do
    Candid::EssentialsV3.configure do |config|
      config.api_token = 'letmein'
    end
  end

  describe 'class methods' do
    it 'sets the base_uri' do
      expect(described_class.base_uri).to eq('https://api.candid.org/essentials/v3')
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

  describe '#search_by_term' do
    let(:api) { described_class.new('letmein') }

    context 'when the response is successful' do
      before do
        stub_request(:post, 'https://api.candid.org/essentials/v3/')
          .with(headers: {
            'Content-Type' => 'application/json',
            'Subscription-Key' => 'letmein'
          })
          .to_return(status: 200, body: { hits: [{ name: 'Test' }] }.to_json)
      end

      it 'returns a list of API resource objects' do
        expect(api.search_by_term('red cross')).to all(be_a(Candid::Shared::Resource))
      end

      it 'allows data JSON to be traversed like an object' do
        expect(api.search_by_term('red cross').first.name).to eq('Test')
      end
    end

    context 'when filtering responses' do
      it 'lets you pass filter terms' do
        stub_request(:post, 'https://api.candid.org/essentials/v3/')
          .with(
            body: { search_terms: 'red cross', filters: { geography: { state: ['CA'] } } }.to_json,
            headers: {
              'Content-Type' => 'application/json',
              'Subscription-Key' => 'letmein'
            }
          )
          .to_return(status: 200, body: { hits: [{ name: 'Test' }] }.to_json)

        api.search_by_term('red cross', filters: { geography: { state: ['CA'] } })
      end

      it 'strips filter from request if none are provided' do
        stub_request(:post, 'https://api.candid.org/essentials/v3/')
          .with(
            body: { search_terms: 'red cross' }.to_json,
            headers: {
              'Content-Type' => 'application/json',
              'Subscription-Key' => 'letmein'
            }
          )
          .to_return(status: 200, body: { hits: [{ name: 'Test' }] }.to_json)

        api.search_by_term('red cross')
      end
    end

    context 'when the response is not successful' do
      before do
        stub_request(:post, 'https://api.candid.org/essentials/v3/')
          .with(headers: {
            'Content-Type' => 'application/json',
            'Subscription-Key' => 'letmein'
          })
          .to_return(status: 404, body: { message: 'Not Found' }.to_json)
      end

      it 'raises an APIError' do
        expect { api.search_by_term('red cross') }.to raise_error(Candid::EssentialsV3::APIError)
      end

      it 'sets the message on the error' do
        api.search_by_term('red cross')
      rescue Candid::EssentialsV3::APIError => e
        expect(e.message).to eq('Not Found')
      end

      it 'sets the response on the error' do
        api.search_by_term('red cross')
      rescue Candid::EssentialsV3::APIError => e
        expect(e.response).to be_a(HTTParty::Response)
      end
    end
  end
end
