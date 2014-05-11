require 'spec_helper'

describe Gitlab::Request do
  it { should respond_to :get }
  it { should respond_to :post }
  it { should respond_to :put }
  it { should respond_to :delete }

  describe ".default_options" do
    it "should have default values" do
      default_options = Gitlab::Request.default_options
      default_options.should be_a Hash
      default_options[:parser].should be_a Proc
      default_options[:format].should == :json
      default_options[:headers].should == {'Accept' => 'application/json'}
      default_options[:default_params].should be_nil
    end
  end

  describe ".parse" do
    it "should return ObjectifiedHash" do
      body = JSON.unparse({a: 1, b: 2})
      Gitlab::Request.parse(body).should be_an Gitlab::ObjectifiedHash
    end
  end

  describe "#set_request_defaults" do
    context "when endpoint is not set" do
      it "should raise Error::MissingCredentials" do
        expect {
          Gitlab::Request.new.set_request_defaults(nil, 1234000)
        }.to raise_error(Gitlab::Error::MissingCredentials, 'Please set an endpoint to API')
      end
    end

    context "when endpoint is set" do
      it "should set base_uri" do
        Gitlab::Request.new.set_request_defaults('http://rabbit-hole.example.org', 1234000)
        Gitlab::Request.base_uri.should == "http://rabbit-hole.example.org"
      end

      it "should set default_params" do
        Gitlab::Request.new.set_request_defaults('http://rabbit-hole.example.org', 1234000, 'sudoer')
        Gitlab::Request.default_params.should == {:sudo => 'sudoer'}
      end
    end
  end
end
