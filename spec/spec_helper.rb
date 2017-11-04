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

%i(get post put delete).each do |method|
  define_method "stub_#{method}" do |path, fixture, status_code=200|
    stub_request(method, "#{Gitlab.endpoint}#{path}")
      .with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
      .to_return(body: load_fixture(fixture), status: status_code)
  end

  define_method "a_#{method}" do |path|
    a_request(method, "#{Gitlab.endpoint}#{path}")
      .with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
  end
end
