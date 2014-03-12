require 'spec_helper'

describe Gitlab do
  after { Gitlab.reset }

  describe ".client" do
    it "should be a Gitlab::Client" do
      Gitlab.endpoint = 'https://api.example.com'
      Gitlab.private_token = 'secret'
      Gitlab.client.should be_a Gitlab::Client
    end
  end

  describe ".endpoint=" do
    it "should set endpoint" do
      Gitlab.endpoint = 'https://api.example.com'
      Gitlab.endpoint.should == 'https://api.example.com'
    end
  end

  describe ".private_token=" do
    it "should set private_token" do
      Gitlab.private_token = 'secret'
      Gitlab.private_token.should == 'secret'
    end
  end

  describe ".sudo=" do
    it "should set sudo" do
      Gitlab.sudo = 'user'
      Gitlab.sudo.should == 'user'
    end
  end

  describe ".user_agent" do
    it "should return default user_agent" do
      Gitlab.user_agent.should == Gitlab::Configuration::DEFAULT_USER_AGENT
    end
  end

  describe ".user_agent=" do
    it "should set user_agent" do
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
