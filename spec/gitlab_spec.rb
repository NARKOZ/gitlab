require 'spec_helper'

describe Gitlab do
  after { Gitlab.reset }

  describe ".client" do
    it "should be a Gitlab::Client" do
      expect(Gitlab.client).to be_a Gitlab::Client
    end
  end

  describe ".actions" do
    it "should return an array of client methods" do
      actions = Gitlab.actions
      expect(actions).to be_an Array
      expect(actions.first).to be_a Symbol
      expect(actions.sort.first).to match(/add_/)
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
end
