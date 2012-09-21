require 'rspec'
require 'webmock/rspec'

require File.expand_path('../../lib/gitlab', __FILE__)

def load_fixture(name)
  File.new(File.dirname(__FILE__) + "/fixtures/#{name}.json")
end

RSpec.configure do |config|
  config.before(:all) do
    Gitlab.base_uri = 'https://api.example.com'
    Gitlab.endpoint = nil
    Gitlab.private_token = 'secret'
  end
end

# GET
def stub_get(path, fixture)
  stub_request(:get, "#{Gitlab.base_uri}#{path}").
    with(:query => {:private_token => Gitlab.private_token}).
    to_return(:body => load_fixture(fixture))
end

def a_get(path)
  a_request(:get, "#{Gitlab.base_uri}#{path}").
    with(:query => {:private_token => Gitlab.private_token})
end

# POST
def stub_post(path, fixture)
  stub_request(:post, "#{Gitlab.base_uri}#{path}").
    with(:query => {:private_token => Gitlab.private_token}).
    to_return(:body => load_fixture(fixture))
end

def a_post(path)
  a_request(:post, "#{Gitlab.base_uri}#{path}").
    with(:query => {:private_token => Gitlab.private_token})
end

# PUT
def stub_put(path, fixture)
  stub_request(:put, "#{Gitlab.base_uri}#{path}").
    with(:query => {:private_token => Gitlab.private_token}).
    to_return(:body => load_fixture(fixture))
end

def a_put(path)
  a_request(:put, "#{Gitlab.base_uri}#{path}").
    with(:query => {:private_token => Gitlab.private_token})
end

# DELETE
def stub_delete(path, fixture)
  stub_request(:delete, "#{Gitlab.base_uri}#{path}").
    with(:query => {:private_token => Gitlab.private_token}).
    to_return(:body => load_fixture(fixture))
end

def a_delete(path)
  a_request(:delete, "#{Gitlab.base_uri}#{path}").
    with(:query => {:private_token => Gitlab.private_token})
end
