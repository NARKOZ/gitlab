# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to avatar.
  # @see https://docs.gitlab.com/ce/api/avatar.html
  module Avatar
    # Get a single avatar URL for a user with the given email address.
    #
    # @example
    #   Gitlab.avatar(email: 'admin@example.com')
    #   Gitlab.avatar(email: 'admin@example.com', size: 32)
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :email(required) Public email address of the user.
    # @option options [Integer] :size(optional) Single pixel dimension (since images are squares). Only used for avatar lookups at Gravatar or at the configured Libravatar server.
    # @return <Gitlab::ObjectifiedHash>
    def avatar(options = {})
      get('/avatar', query: options)
    end
  end
end
