# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to templates.
  # @see https://docs.gitlab.com/ce/api/templates/dockerfiles.html
  # @see https://docs.gitlab.com/ce/api/templates/gitignores.html
  # @see https://docs.gitlab.com/ce/api/templates/gitlab_ci_ymls.html
  # @see https://docs.gitlab.com/ce/api/templates/licenses.html
  module Templates
    # Get all Dockerfile templates.
    #
    # @example
    #   Gitlab::Client.dockerfile_templates
    #
    # @return [Array<Gitlab::Client::ObjectifiedHash>]
    def dockerfile_templates
      get('/templates/dockerfiles')
    end

    # Get a single Dockerfile template.
    #
    # @example
    #   Gitlab::Client.dockerfile_template('Binary')
    #
    # @param  [String] key The key of the Dockerfile template
    # @return [Gitlab::Client::ObjectifiedHash]
    def dockerfile_template(key)
      get("/templates/dockerfiles/#{key}")
    end

    # Get all gitignore templates.
    #
    # @example
    #   Gitlab::Client.gitignore_templates
    #
    # @return [Array<Gitlab::Client::ObjectifiedHash>]
    def gitignore_templates
      get('/templates/gitignores')
    end

    # Get a single gitignore template.
    #
    # @example
    #   Gitlab::Client.gitignore_template('Ruby')
    #
    # @param  [String] key The key of the gitignore template
    # @return [Gitlab::Client::ObjectifiedHash]
    def gitignore_template(key)
      get("/templates/gitignores/#{key}")
    end

    # Get all `gitlab_ci.yml` templates.
    #
    # @example
    #   Gitlab::Client.gitlab_ci_yml_templates
    #
    # @return [Array<Gitlab::Client::ObjectifiedHash>]
    def gitlab_ci_yml_templates
      get('/templates/gitlab_ci_ymls')
    end

    # Get a single `gitlab_ci.yml` template.
    #
    # @example
    #   Gitlab::Client.gitlab_ci_yml_template('Ruby')
    #
    # @param  [String] key The key of the gitlab_ci_yml template
    # @return [Gitlab::Client::ObjectifiedHash]
    def gitlab_ci_yml_template(key)
      get("/templates/gitlab_ci_ymls/#{key}")
    end

    # Get all license templates.
    #
    # @example
    #   Gitlab::Client.license_templates
    #   Gitlab::Client.license_templates(popular: true)
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Boolean] popular(optional) If passed, returns only popular licenses.
    # @return [Array<Gitlab::Client::ObjectifiedHash>]
    def license_templates(options = {})
      get('/templates/licenses', query: options)
    end

    # Get a single license template. You can pass parameters to replace the license placeholder.
    #
    # @example
    #   Gitlab::Client.license_template('Ruby')
    #
    # @param  [String] key The key of the license template
    # @param  [Hash] options A customizable set of options.
    # @option options [String] project(optional) The copyrighted project name.
    # @option options [String] fullname(optional) The full-name of the copyright holder
    # @return [Gitlab::Client::ObjectifiedHash]
    def license_template(key, options = {})
      get("/templates/licenses/#{key}", query: options)
    end
  end
end
