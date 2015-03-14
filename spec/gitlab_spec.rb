require 'spec_helper'

describe Gitlab do
  after { Gitlab.reset }

  describe ".client" do
    it "should be a Gitlab::Client" do
      expect(Gitlab.client).to be_a Gitlab::Client
    end

    it "should not override each other" do
      client1 = Gitlab.client(endpoint: 'https://api1.example.com', private_token: '001')
      client2 = Gitlab.client(endpoint: 'https://api2.example.com', private_token: '002')
      expect(client1.endpoint).to eq('https://api1.example.com')
      expect(client2.endpoint).to eq('https://api2.example.com')
      expect(client1.private_token).to eq('001')
      expect(client2.private_token).to eq('002')
    end

    it "should set private_token to the auth_token when provided" do
      client = Gitlab.client(endpoint: 'https://api2.example.com', auth_token: '3225e2804d31fea13fc41fc83bffef00cfaedc463118646b154acc6f94747603')
      expect(client.private_token).to eq('3225e2804d31fea13fc41fc83bffef00cfaedc463118646b154acc6f94747603')
    end
  end

  describe ".actions" do
    it "should return an array of client methods" do
      actions = Gitlab.actions
      expect(actions).to be_an Array
      expect(actions.first).to be_a Symbol
      expect(actions.sort.first).to eq(:accept_merge_request)
    end
  end

  describe ".endpoint=" do
    it "should set endpoint" do
      Gitlab.endpoint = 'https://api.example.com'
      expect(Gitlab.endpoint).to eq('https://api.example.com')
    end
  end

  describe ".private_token=" do
    it "should set private_token" do
      Gitlab.private_token = 'secret'
      expect(Gitlab.private_token).to eq('secret')
    end
  end

  describe ".auth_token=" do
    it "should set auth_token", focus: true do
      Gitlab.auth_token = 'auth_secret'
      expect(Gitlab.private_token).to eq('auth_secret')
    end
  end

  describe ".sudo=" do
    it "should set sudo" do
      Gitlab.sudo = 'user'
      expect(Gitlab.sudo).to eq('user')
    end
  end

  describe ".user_agent" do
    it "should return default user_agent" do
      expect(Gitlab.user_agent).to eq(Gitlab::Configuration::DEFAULT_USER_AGENT)
    end
  end

  describe ".user_agent=" do
    it "should set user_agent" do
      Gitlab.user_agent = 'Custom User Agent'
      expect(Gitlab.user_agent).to eq('Custom User Agent')
    end
  end

  describe ".configure" do
    Gitlab::Configuration::VALID_OPTIONS_KEYS.each do |key|
      it "should set #{key}" do
        Gitlab.configure do |config|
          config.send("#{key}=", key)
          expect(Gitlab.send(key)).to eq(key)
        end
      end
    end
  end

  describe ".http_proxy" do
    it "delegates the method to Gitlab::Request" do
      Gitlab.endpoint = 'https://api.example.com'
      request = class_spy(Gitlab::Request).as_stubbed_const

      Gitlab.http_proxy('fazbearentertainment.com', 1987, 'ffazbear', 'itsme')
      expect(request).to have_received(:http_proxy).
        with('fazbearentertainment.com', 1987, 'ffazbear', 'itsme')
    end
  end
end
