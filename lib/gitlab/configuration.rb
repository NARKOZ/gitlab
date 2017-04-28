require 'gitlab/cli_helpers'
module Gitlab
  # Defines constants and methods related to configuration.
  module Configuration
    # An array of valid keys in the options hash when configuring a Gitlab::API.
    VALID_OPTIONS_KEYS = [:endpoint, :private_token, :login, :password, :user_agent, :sudo, :httparty].freeze

    # The user agent that will be sent to the API endpoint if none is set.
    DEFAULT_USER_AGENT = "Gitlab Ruby Gem #{Gitlab::VERSION}".freeze

    # @private
    attr_accessor(*VALID_OPTIONS_KEYS)
    # @private
    alias_method :auth_token=, :private_token=

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
      self.endpoint       = ENV['GITLAB_API_ENDPOINT']
      self.private_token  = ENV['GITLAB_API_PRIVATE_TOKEN'] || ENV['GITLAB_API_AUTH_TOKEN']
      self.httparty       = get_httparty_config(ENV['GITLAB_API_HTTPARTY_OPTIONS'])
      self.login          = nil
      self.password       = nil
      self.sudo           = nil
      self.user_agent     = DEFAULT_USER_AGENT
    end

    private

    # Allows HTTParty config to be specified in ENV using YAML hash.
    def get_httparty_config(options)
      return options if options.nil?

      httparty = Gitlab::CLI::Helpers.yaml_load(options)

      raise ArgumentError, "HTTParty config should be a Hash." unless httparty.is_a? Hash
      Gitlab::CLI::Helpers.symbolize_keys httparty
    end
  end
end
