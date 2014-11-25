require 'spec_helper'

describe Gitlab::Request do
  it { should respond_to :get }
  it { should respond_to :post }
  it { should respond_to :put }
  it { should respond_to :delete }

  describe "pagination" do
    context "when requesting the first page of users" do
      it "should find the 'next' link in the headers" do
        stub_page_1_get("/users", "users")
        response = Gitlab.http_response_for(:get, "/users")
        nexturl = Gitlab.rels(response.headers)['next']
        expect(nexturl).to_not be nil
      end
    end

    context "when requesting with auto_paginate false" do
      context "and per_page=1" do
        it "should only return one user record (and not in an array)" do
          stub_page_1_get("/users?per_page=1", "user")
          Gitlab.auto_paginate = false
          result = Gitlab.users per_page: 1
          expect(result).to be_a Gitlab::ObjectifiedHash # (and not an Array)
        end
      end
      context "and per_page more than 1" do
        it "should return an array of several user records" do
          stub_page_1_get("/users?per_page=7", "users")
          Gitlab.auto_paginate = false
          result = Gitlab.users per_page: 7
          expect(result).to be_a Array
          expect(result.count).to eql 7
        end
      end
    end

    context "when requesting with auto_paginate true" do
      it "should make multiple requests for results" do
        stub_page_1_get("/users?per_page=1", "user")
        stub_page_2_get("/users?page=2&per_page=1", "user") # for this test, don't mind returning copies of same user
        stub_page_3_get("/users?page=3&per_page=1", "user")
        Gitlab.auto_paginate = true
        result = Gitlab.users per_page: 1
        expect(result).to be_a Array
        expect(result.count).to eql 3
      end

      context "and more than one result per page" do
        it "should return a flat result list of the right size" do
          stub_page_1_get("/users?per_page=1", "users")
          stub_page_2_get("/users?page=2&per_page=1", "users")
          stub_page_3_get("/users?page=3&per_page=1", "users")
          Gitlab.auto_paginate = true
          result = Gitlab.users per_page: 1
          expect(result).to be_a Array
          expect(result.count).to eql 21
        end
      end
    end
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
          Gitlab::Request.new.set_request_defaults(nil, 1234000)
        }.to raise_error(Gitlab::Error::MissingCredentials, 'Please set an endpoint to API')
      end
    end

    context "when endpoint is set" do
      it "should set base_uri" do
        Gitlab::Request.new.set_request_defaults('http://rabbit-hole.example.org', 1234000)
        expect(Gitlab::Request.base_uri).to eq("http://rabbit-hole.example.org")
      end

      it "should set default_params" do
        Gitlab::Request.new.set_request_defaults('http://rabbit-hole.example.org', 1234000, 'sudoer')
        expect(Gitlab::Request.default_params).to eq({:sudo => 'sudoer'})
      end
    end
  end
end
