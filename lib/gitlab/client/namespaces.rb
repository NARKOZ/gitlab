# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to namespaces
  # @see https://docs.gitlab.com/ce/api/namespaces.html
  module Namespaces
    # Gets a list of namespaces.
    # @see https://docs.gitlab.com/ce/api/namespaces.html#list-namespaces
    #
    # @example
    #   Gitlab.namespaces
    #
    # @param  [Hash] options A customizable set of options.
    # @options options [Integer] :page The page number.
    # @options options [Integer] :per_page The number of results per page.
    # @options opttion [String]  :search The string to search for.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def namespaces(options = {})
      get('/namespaces', query: options)
    end
  end
end
