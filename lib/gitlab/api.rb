module Gitlab
  # @private
  class API < Request
    # @private
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)
    # @private
    alias_method :auth_token=, :private_token=

    # Creates a new API.
    # @raise [Error:MissingCredentials]
    def initialize(options={})
      options = Gitlab.options.merge(options)
      (Configuration::VALID_OPTIONS_KEYS + [:auth_token]).each do |key|
        send("#{key}=", options[key]) if options[key]
      end
      set_request_defaults(@sudo)
    end
  end
end
