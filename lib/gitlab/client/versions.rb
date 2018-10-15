# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to version
  # @see https://docs.gitlab.com/ce/api/version.html
  module Versions
    # Returns server version.
    # @see https://docs.gitlab.com/ce/api/version.html
    #
    # @example
    #   Gitlab.version
    #
    # @return [Array<Gitlab::ObjectifiedHash>]
    def version
      get('/version')
    end
  end
end
