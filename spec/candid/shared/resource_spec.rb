# frozen_string_literal: true

RSpec.describe Candid::Shared::Resource do
  before do
    Candid::PremierV3.configure do |config|
      config.api_token = '12345'
    end
  end

  describe '#initialize' do
    it 'deep-transforms data attribute keys to symbols' do
      data = { 'name' => 'Foo', 'nested' => { 'id' => 1 } }
      resource = described_class.new(data)

      expect(resource.data).to include({ name: 'Foo' })
      expect(resource.data[:nested].data).to eq({ id: 1 })
    end

    it 'creates nested resources for hashes' do
      data = { 'nested' => { 'id' => 1 } }
      resource = described_class.new(data)

      expect(resource.nested).to be_a(described_class)
    end

    it 'creates nested resources for arrays' do
      data = { 'nested' => [{ 'id' => 1 }, 'asdf'] }
      resource = described_class.new(data)

      expect(resource.nested).to be_a(Array)
      expect(resource.nested.first).to be_a(described_class)
      expect(resource.nested.last).to be_a(String)
    end

    it 'allows you to set HTTP response' do
      resource = described_class.new({}, 'response')

      expect(resource.response).to eq('response')
    end

    it 'sets a default value for HTTP response' do
      resource = described_class.new({})

      expect(resource.response).to eq(nil)
    end
  end

  describe '#to_h' do
    it 'returns the raw data as a hash' do
      data = { 'name' => 'Foo', 'nested' => { 'id' => 1 } }
      resource = described_class.new(data)

      expect(resource.to_h).to eq(data)
    end
  end

  describe '#to_s' do
    it 'returns the raw data as a string' do
      data = { 'name' => 'Foo', 'nested' => { 'id' => 1 } }
      resource = described_class.new(data)

      expect(resource.to_s).to eq(data.to_s)
    end
  end

  describe '#method_missing' do
    it 'delegates to the data attribute' do
      data = { 'name' => 'Foo' }
      resource = described_class.new(data)

      expect(resource.name).to eq(data['name'])
    end

    it 'delegates to the data attribute even if its value is false' do
      data = { 'is_active' => false }
      resource = described_class.new(data)

      expect(resource.is_active).to eq(data['is_active'])
    end

    it 'raises an error if the data attribute does not respond to the method' do
      resource = described_class.new({})

      expect { resource.foo }.to raise_error(NoMethodError)
    end
  end

  describe '#respond_to_missing?' do
    it 'returns true if the data attribute responds to the method' do
      data = { 'name' => 'Foo' }
      resource = described_class.new(data)

      expect(resource.respond_to?(:name)).to be(true)
    end

    it 'returns false if the data attribute does not respond to the method' do
      resource = described_class.new({})

      expect(resource.respond_to?(:foo)).to be(false)
    end
  end
end
