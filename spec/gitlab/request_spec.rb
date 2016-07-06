require 'spec_helper'

describe Gitlab::Request do
  it { should respond_to :get }
  it { should respond_to :post }
  it { should respond_to :put }
  it { should respond_to :delete }
  before do
    @request = Gitlab::Request.new
  end

  describe ".default_options" do
    it "should have default values" do
      default_options = Gitlab::Request.default_options
      expect(default_options).to be_a Hash
      expect(default_options[:parser]).to be_a Proc
      expect(default_options[:format]).to eq(:json)
      expect(default_options[:headers]).to eq('Accept' => 'application/json')
      expect(default_options[:default_params]).to be_nil
    end
  end

  describe ".parse" do
    it "should return ObjectifiedHash" do
      body = JSON.unparse(a: 1, b: 2)
      expect(Gitlab::Request.parse(body)).to be_an Gitlab::ObjectifiedHash
      expect(Gitlab::Request.parse("true")).to be true
      expect(Gitlab::Request.parse("false")).to be false

      expect { Gitlab::Request.parse("string") }.to raise_error(Gitlab::Error::Parsing)
    end
  end

  describe "#set_request_defaults" do
    context "when endpoint is not set" do
      it "should raise Error::MissingCredentials" do
        @request.endpoint = nil
        expect do
          @request.set_request_defaults
        end.to raise_error(Gitlab::Error::MissingCredentials, 'Please set an endpoint to API')
      end
    end

    context "when endpoint is set" do
      before(:each) do
        @request.endpoint = 'http://rabbit-hole.example.org'
      end

      it "should set default_params" do
        @request.set_request_defaults('sudoer')
        expect(Gitlab::Request.default_params).to eq(sudo: 'sudoer')
      end
    end
  end

  describe "#set_authorization_header" do
    it "should raise MissingCredentials when auth_token and private_token are not set" do
      expect do
        @request.send(:set_authorization_header, {})
      end.to raise_error(Gitlab::Error::MissingCredentials)
    end

    it "should set the correct header when given a private_token" do
      @request.private_token = 'ys9BtunN3rDKbaJCYXaN'
      expect(@request.send(:set_authorization_header, {})).to eq("PRIVATE-TOKEN" => 'ys9BtunN3rDKbaJCYXaN')
    end

    it "should set the correct header when setting an auth_token via the private_token config option" do
      @request.private_token = '3225e2804d31fea13fc41fc83bffef00cfaedc463118646b154acc6f94747603'
      expect(@request.send(:set_authorization_header, {})).to eq("Authorization" => "Bearer 3225e2804d31fea13fc41fc83bffef00cfaedc463118646b154acc6f94747603")
    end
  end
end
