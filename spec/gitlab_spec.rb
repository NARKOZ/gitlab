require 'spec_helper'

describe Gitlab do
  after { Gitlab.reset }

  describe ".client" do
    it "should be a Gitlab::Client" do
      Gitlab.client.should be_a Gitlab::Client
    end
  end

  describe ".base_uri=" do
    it "should set base_uri" do
      Gitlab.base_uri = 'https://api.example.com'
      Gitlab.base_uri.should == 'https://api.example.com'
    end
  end

  describe ".endpoint" do
    it "should return default endpoint" do
      Gitlab.endpoint.should == Gitlab::Configuration::DEFAULT_ENDPOINT
    end
  end

  describe ".endpoint=" do
    it "should set endpoint" do
      Gitlab.endpoint = nil
      Gitlab.endpoint.should be_nil
    end
  end

  describe ".private_token=" do
    it "should set private token" do
      Gitlab.private_token = 'secret'
      Gitlab.private_token.should == 'secret'
    end
  end

  describe ".user_agent" do
    it "should return default user agent" do
      Gitlab.user_agent.should == Gitlab::Configuration::DEFAULT_USER_AGENT
    end
  end

  describe ".user_agent=" do
    it "should set user agent" do
      Gitlab.user_agent = 'Custom User Agent'
      Gitlab.user_agent.should == 'Custom User Agent'
    end
  end

  describe ".configure" do
    Gitlab::Configuration::VALID_OPTIONS_KEYS.each do |key|
      it "should set #{key}" do
        Gitlab.configure do |config|
          config.send("#{key}=", key)
          Gitlab.send(key).should == key
        end
      end
    end
  end
end
