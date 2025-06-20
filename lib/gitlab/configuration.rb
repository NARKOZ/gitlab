# frozen_string_literal: true

require 'gitlab/cli_helpers'
module Gitlab
  # Defines constants and methods related to configuration.
  module Configuration
    # An array of valid keys in the options hash when configuring a Gitlab::API.
    VALID_OPTIONS_KEYS = %i[endpoint private_token user_agent sudo httparty pat_prefix body_as_json
                            before_hooks around_hooks after_hooks].freeze

    # The user agent that will be sent to the API endpoint if none is set.
    DEFAULT_USER_AGENT = "Gitlab Ruby Gem #{Gitlab::VERSION}"

    # @private
    attr_accessor(*VALID_OPTIONS_KEYS)
    # @private
    alias auth_token= private_token=

    # Sets all configuration options to their default values
    # when this module is extended.
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block.
    def configure
      yield self
    end

    # Creates a hash of options and their values.
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Resets all configuration options to the defaults.
    def reset
      self.endpoint       = ENV['GITLAB_API_ENDPOINT'] || ENV['CI_API_V4_URL']
      self.private_token  = ENV['GITLAB_API_PRIVATE_TOKEN'] || ENV['GITLAB_API_AUTH_TOKEN']
      self.pat_prefix     = nil
      self.httparty       = get_httparty_config(ENV['GITLAB_API_HTTPARTY_OPTIONS'])
      self.sudo           = nil
      self.user_agent     = DEFAULT_USER_AGENT
      self.body_as_json   = false
      self.before_hooks   = []
      self.around_hooks   = [Gitlab::Configuration.method(:handle_too_many_requests)]
      self.after_hooks    = []
    end

    def self.handle_too_many_requests(_method, _path, params, block)
      retries_left = params[:ratelimit_retries] || 3
      begin
        block.call
      rescue Gitlab::Error::TooManyRequests => e
        retries_left -= 1
        raise e if retries_left.zero?

        wait_time = e.response_headers['Retry-After'] || 2
        sleep(wait_time.to_i)
        retry
      end
    end

    private

    # Allows HTTParty config to be specified in ENV using YAML hash.
    def get_httparty_config(options)
      return if options.nil?

      httparty = Gitlab::CLI::Helpers.yaml_load(options)
      raise ArgumentError, 'HTTParty config should be a Hash.' unless httparty.is_a? Hash

      Gitlab::CLI::Helpers.symbolize_keys httparty
    end
  end
end
