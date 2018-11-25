# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to licenses.
  # @see https://docs.gitlab.com/ce/api/templates/licenses.html
  module LicenseTemplates
    # Get all license templates.
    #
    # @example
    #   Gitlab.license_templates
    #   Gitlab.license_templates(popular: true)
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Boolean] popular(optional) If passed, returns only popular licenses.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def license_templates(options = {})
      get('/templates/licenses', query: options)
    end

    # Get a single license template. You can pass parameters to replace the license placeholder.
    #
    # @example
    #   Gitlab.license_template('Ruby')
    #
    # @param  [String] key The key of the license template
    # @param  [Hash] options A customizable set of options.
    # @option options [String] project(optional) The copyrighted project name.
    # @option options [String] fullname(optional) The full-name of the copyright holder
    # @return [Gitlab::ObjectifiedHash]
    def license_template(key, options = {})
      get("/templates/licenses/#{key}", query: options)
    end
  end
end
