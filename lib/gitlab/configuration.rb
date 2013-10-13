module Gitlab
  # Defines constants and methods related to configuration.
  module Configuration
    # An array of valid keys in the options hash when configuring a Gitlab::API.
    VALID_OPTIONS_KEYS = [:endpoint, :private_token, :user_agent, :sudo].freeze

    # The user agent that will be sent to the API endpoint if none is set.
    DEFAULT_USER_AGENT = "Gitlab Ruby Gem #{Gitlab::VERSION}".freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

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
      self.endpoint       = nil
      self.private_token  = nil
      self.sudo           = nil
      self.user_agent     = DEFAULT_USER_AGENT
    end
  end
end
