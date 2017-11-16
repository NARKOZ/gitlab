class Gitlab::Client
  # Defines methods related to licenses.
  # @see https://docs.gitlab.com/ce/api/licenses.html
  module Licenses
    # Gets a list of project licenses.
    #
    # @example
    #   Gitlab.licenses
    #   Gitlab.licenses({ popular: 1 })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :popular pass 1 to only return popular licenses.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def licenses(options={})
      get("/templates/licenses", query: options)
    end

    # Gets a single license.
    #
    # @example
    #   Gitlab.license('apache-2.0')
    #
    # @param  [Integer] key The key of a license.
    # @return [Gitlab::ObjectifiedHash]
    def license(key)
      get("/templates/licenses/#{key}")
    end
  end
end
