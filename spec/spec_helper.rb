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

def stub_page_1_get(path, fixture)
  # Normally, the 'Link' headers include a "per_page" param, but the API call tacks one on, so it's not
  # in these URLs in order to avoid duplicating the param in a subsequent call.
  stub_request(:get, "#{Gitlab.endpoint}#{path}").
      with(:headers => {'PRIVATE-TOKEN' => Gitlab.private_token}).
      to_return(body: load_fixture(fixture), :headers => { 'Link' => "<#{Gitlab.endpoint}/users?page=2>; rel=\"next\">, <#{Gitlab.endpoint}/users?page=1>; rel=\"first\">, <#{Gitlab.endpoint}/users?page=3>; rel=\"last\">" })
end

def stub_page_2_get(path, fixture)
  stub_request(:get, "#{Gitlab.endpoint}#{path}").
      with(:headers => {'PRIVATE-TOKEN' => Gitlab.private_token}).
      to_return(body: load_fixture(fixture), :headers => { 'Link' => "<#{Gitlab.endpoint}/users?page=1>; rel=\"prev\">, <#{Gitlab.endpoint}/users?page=3>; rel=\"next\">, <#{Gitlab.endpoint}/users?page=1>; rel=\"first\">, <#{Gitlab.endpoint}/users?page=3>; rel=\"last\">" })
end

def stub_page_3_get(path, fixture)
  stub_request(:get, "#{Gitlab.endpoint}#{path}").
      with(:headers => {'PRIVATE-TOKEN' => Gitlab.private_token}).
      to_return(body: load_fixture(fixture), :headers => { 'Link' => "<#{Gitlab.endpoint}/users?page=2>; rel=\"prev\">, <#{Gitlab.endpoint}/users?page=1>; rel=\"first\">, <#{Gitlab.endpoint}/users?page=3>; rel=\"last\">" })
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
