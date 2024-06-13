# frozen_string_literal: true

require 'rspec'
require 'webmock/rspec'

require File.expand_path('../lib/gitlab', __dir__)
require File.expand_path('../lib/gitlab/cli', __dir__)

def load_fixture(name)
  name, extension = name.split('.')
  File.new(File.dirname(__FILE__) + "/fixtures/#{name}.#{extension || 'json'}")
end

RSpec.configure do |config|
  config.before(:all) do
    Gitlab.endpoint = 'https://api.example.com'
    Gitlab.private_token = 'secret'
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # TODO: set to true
    mocks.verify_partial_doubles = false
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random

  Kernel.srand config.seed
end

%i[get post put delete patch].each do |method|
  define_method "stub_#{method}" do |path, fixture, status_code = 200|
    stub_request(method, "#{Gitlab.endpoint}#{path}")
      .with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
      .to_return(body: load_fixture(fixture), status: status_code)
  end

  define_method "a_#{method}" do |path|
    a_request(method, "#{Gitlab.endpoint}#{path}")
      .with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
  end
end
