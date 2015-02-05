require 'spec_helper'

describe Gitlab::Request do
  it { should respond_to :get }
  it { should respond_to :post }
  it { should respond_to :put }
  it { should respond_to :delete }
  before do
    @request = Gitlab::Request.new
    @obj_h = Gitlab::ObjectifiedHash.new({user: ['not set'],
                                          password: ['too short'],
                                          embed_entity: { foo: ['bar'], sna: ['fu'] }})
  end

  describe ".default_options" do
    it "should have default values" do
      default_options = Gitlab::Request.default_options
      expect(default_options).to be_a Hash
      expect(default_options[:parser]).to be_a Proc
      expect(default_options[:format]).to eq(:json)
      expect(default_options[:headers]).to eq({'Accept' => 'application/json'})
      expect(default_options[:default_params]).to be_nil
    end
  end

  describe ".parse" do
    it "should return ObjectifiedHash" do
      body = JSON.unparse({a: 1, b: 2})
      expect(Gitlab::Request.parse(body)).to be_an Gitlab::ObjectifiedHash
    end
  end

  describe "#set_request_defaults" do
    context "when endpoint is not set" do
      it "should raise Error::MissingCredentials" do
        expect {
          @request.set_request_defaults(nil, 1234000, 1234000)
        }.to raise_error(Gitlab::Error::MissingCredentials, 'Please set an endpoint to API')
      end
    end

    context "when endpoint is set" do
      it "should set instance variable 'endpoint'" do
        @request.set_request_defaults('http://rabbit-hole.example.org', 1234000, 1234000)
        expect(@request.instance_variable_get(:@endpoint)).to eq("http://rabbit-hole.example.org")
      end

      it "should set default_params" do
        Gitlab::Request.new.set_request_defaults('http://rabbit-hole.example.org', 1234000, 1234000, 'sudoer')
        expect(Gitlab::Request.default_params).to eq({:sudo => 'sudoer'})
      end
    end
  end

  describe "#set_authorization_header" do
    it "should raise MissingCredentials when auth_token and private_token are not set" do
      expect {
        @request.send(:set_authorization_header, {})
      }.to raise_error(Gitlab::Error::MissingCredentials)
    end

    it "should set the correct header when given a private_token" do
      @request.private_token = 1234000
      expect(@request.send(:set_authorization_header, {})).to eq({"PRIVATE-TOKEN"=>1234000})
    end

    it "should set the correct header when given a auth_token" do
      @request.auth_token = 1234000
      expect(@request.send(:set_authorization_header, {})).to eq({"Authorization"=>"Bearer 1234000"})
    end
  end

  describe "#handle_error" do
    context "when passed an ObjectifiedHash" do
      it "should return a joined string of error messages sorted by key" do
        expect(@request.send(:handle_error, @obj_h)).to eq("'embed_entity' (foo: bar) (sna: fu), 'password' too short, 'user' not set")
      end
    end

    context "when passed a String" do
      it "should return the String untouched" do
        error = 'this is an error string'
        expect(@request.send(:handle_error, error)).to eq('this is an error string')
      end
    end
  end

end
