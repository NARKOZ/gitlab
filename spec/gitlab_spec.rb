# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab do
  after { described_class.reset }

  describe '.client' do
    it 'is a Gitlab::Client' do
      described_class.endpoint = 'https://api.example.com'
      expect(described_class.client).to be_a Gitlab::Client
    end

    it 'does not override each other' do
      client1 = described_class.client(endpoint: 'https://api1.example.com', private_token: '001')
      client2 = described_class.client(endpoint: 'https://api2.example.com', private_token: '002')
      expect(client1.endpoint).to eq('https://api1.example.com')
      expect(client2.endpoint).to eq('https://api2.example.com')
      expect(client1.private_token).to eq('001')
      expect(client2.private_token).to eq('002')
    end

    it 'sets private_token to the auth_token when provided' do
      client = described_class.client(endpoint: 'https://api2.example.com', auth_token: '3225e2804d31fea13fc41fc83bffef00cfaedc463118646b154acc6f94747603')
      expect(client.private_token).to eq('3225e2804d31fea13fc41fc83bffef00cfaedc463118646b154acc6f94747603')
    end
  end

  describe '.actions' do
    it 'returns an array of client methods' do
      actions = described_class.actions
      expect(actions).to be_an Array
      expect(actions.first).to be_a Symbol
      expect(actions.min).to eq(:accept_merge_request)
    end
  end

  describe '.endpoint=' do
    it 'sets endpoint' do
      described_class.endpoint = 'https://api.example.com'
      expect(described_class.endpoint).to eq('https://api.example.com')
    end
  end

  describe '.private_token=' do
    it 'sets private_token' do
      described_class.private_token = 'secret'
      expect(described_class.private_token).to eq('secret')
    end
  end

  describe '.auth_token=' do
    it 'sets auth_token' do
      described_class.auth_token = 'auth_secret'
      expect(described_class.private_token).to eq('auth_secret')
    end
  end

  describe '.sudo=' do
    it 'sets sudo' do
      described_class.sudo = 'user'
      expect(described_class.sudo).to eq('user')
    end
  end

  describe '.user_agent' do
    it 'returns default user_agent' do
      expect(described_class.user_agent).to eq(Gitlab::Configuration::DEFAULT_USER_AGENT)
    end
  end

  describe '.user_agent=' do
    it 'sets user_agent' do
      described_class.user_agent = 'Custom User Agent'
      expect(described_class.user_agent).to eq('Custom User Agent')
    end
  end

  describe '.configure' do
    Gitlab::Configuration::VALID_OPTIONS_KEYS.each do |key|
      it "sets #{key}" do
        described_class.configure do |config|
          config.send("#{key}=", key)
          expect(described_class.send(key)).to eq(key)
        end
      end
    end
  end

  describe '.http_proxy' do
    it 'delegates the method to Gitlab::Request' do
      described_class.endpoint = 'https://api.example.com'
      request = class_spy(Gitlab::Request).as_stubbed_const

      described_class.http_proxy('proxy.example.net', 1987, 'user', 'pass')
      expect(request).to have_received(:http_proxy).with('proxy.example.net', 1987, 'user', 'pass')
    end
  end
end
