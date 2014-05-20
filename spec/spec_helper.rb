require 'rspec'
require 'webmock/rspec'

require File.expand_path('../../lib/gitlab', __FILE__)
require File.expand_path('../../lib/gitlab/cli', __FILE__)

def capture_output
  out = StringIO.new
  $stdout = out
  $stderr = out
  yield
  $stdout = STDOUT
  $stderr = STDERR
  out.string
end

def load_fixture(name)
  File.new(File.dirname(__FILE__) + "/fixtures/#{name}.json")
end

RSpec.configure do |config|
  config.before(:all) do
    Gitlab.endpoint = 'https://api.example.com'
    Gitlab.private_token = 'secret'
  end
end

# GET
def stub_get(path, fixture)
  stub_request(:get, "#{Gitlab.endpoint}#{path}").
    with(:headers => {'PRIVATE-TOKEN' => Gitlab.private_token}).
    to_return(:body => load_fixture(fixture))
end

def a_get(path)
  a_request(:get, "#{Gitlab.endpoint}#{path}").
    with(:headers => {'PRIVATE-TOKEN' => Gitlab.private_token})
end

# POST
def stub_post(path, fixture, status_code=200)
  stub_request(:post, "#{Gitlab.endpoint}#{path}").
    with(:headers => {'PRIVATE-TOKEN' => Gitlab.private_token}).
    to_return(:body => load_fixture(fixture), :status => status_code)
end

def a_post(path)
  a_request(:post, "#{Gitlab.endpoint}#{path}").
    with(:headers => {'PRIVATE-TOKEN' => Gitlab.private_token})
end

# PUT
def stub_put(path, fixture)
  stub_request(:put, "#{Gitlab.endpoint}#{path}").
    with(:headers => {'PRIVATE-TOKEN' => Gitlab.private_token}).
    to_return(:body => load_fixture(fixture))
end

def a_put(path)
  a_request(:put, "#{Gitlab.endpoint}#{path}").
    with(:headers => {'PRIVATE-TOKEN' => Gitlab.private_token})
end

# DELETE
def stub_delete(path, fixture)
  stub_request(:delete, "#{Gitlab.endpoint}#{path}").
    with(:headers => {'PRIVATE-TOKEN' => Gitlab.private_token}).
    to_return(:body => load_fixture(fixture))
end

def a_delete(path)
  a_request(:delete, "#{Gitlab.endpoint}#{path}").
    with(:headers => {'PRIVATE-TOKEN' => Gitlab.private_token})
end
