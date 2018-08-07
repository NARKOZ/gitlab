# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Request do
  it { is_expected.to respond_to :get }
  it { is_expected.to respond_to :post }
  it { is_expected.to respond_to :put }
  it { is_expected.to respond_to :delete }
  before do
    @request = described_class.new
  end

  describe '.default_options' do
    it 'has default values' do
      default_options = described_class.default_options
      expect(default_options).to be_a Hash
      expect(default_options[:parser]).to be_a Proc
      expect(default_options[:format]).to eq(:json)
      expect(default_options[:headers]).to eq('Accept' => 'application/json', 'Content-Type' => 'application/x-www-form-urlencoded')
      expect(default_options[:default_params]).to be_nil
    end
  end

  describe '.parse' do
    it 'returns ObjectifiedHash' do
      body = JSON.unparse(a: 1, b: 2)
      expect(described_class.parse(body)).to be_an Gitlab::ObjectifiedHash
      expect(described_class.parse('true')).to be true
      expect(described_class.parse('false')).to be false

      expect { described_class.parse('string') }.to raise_error(Gitlab::Error::Parsing)
    end
  end

  describe '#request_defaults' do
    context 'when endpoint is not set' do
      it 'raises Error::MissingCredentials' do
        @request.endpoint = nil
        expect do
          @request.request_defaults
        end.to raise_error(Gitlab::Error::MissingCredentials, 'Please set an endpoint to API')
      end
    end

    context 'when endpoint is set' do
      before do
        @request.endpoint = 'http://rabbit-hole.example.com'
      end

      it 'sets default_params' do
        @request.request_defaults('sudoer')
        expect(described_class.default_params).to eq(sudo: 'sudoer')
      end
    end
  end

  describe '#authorization_header' do
    it 'raises MissingCredentials when auth_token and private_token are not set' do
      expect do
        @request.send(:authorization_header, {})
      end.to raise_error(Gitlab::Error::MissingCredentials)
    end

    it 'sets the correct header when given a private_token' do
      @request.private_token = 'ys9BtunN3rDKbaJCYXaN'
      expect(@request.send(:authorization_header, {})).to eq('PRIVATE-TOKEN' => 'ys9BtunN3rDKbaJCYXaN')
    end

    it 'sets the correct header when setting an auth_token via the private_token config option' do
      @request.private_token = '3225e2804d31fea13fc41fc83bffef00cfaedc463118646b154acc6f94747603'
      expect(@request.send(:authorization_header, {})).to eq('Authorization' => 'Bearer 3225e2804d31fea13fc41fc83bffef00cfaedc463118646b154acc6f94747603')
    end
  end
end
