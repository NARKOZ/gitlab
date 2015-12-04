class Gitlab::Client
  # Defines methods related to namespaces
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/namespaces.md
  module Namespaces
    # Gets a list of namespaces.
    #
    # @example
    #   Gitlab.namespaces
    #
    # @param  [Hash] options A customizable set of options.
    # @options options [Integer] :page The page number.
    # @options options [Integer] :per_page The number of results per page.
    # @options opttion [String]  :search The string to search for.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def namespaces(options={})
      get("/namespaces", query: options)
    end
  end
end
