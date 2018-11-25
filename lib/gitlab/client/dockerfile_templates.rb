# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to Dockerfile templates.
  # @see https://docs.gitlab.com/ce/api/templates/dockerfiles.html
  module DockerfileTemplates
    # Get all Dockerfile templates.
    #
    # @example
    #   Gitlab.dockerfile_templates
    #
    # @return [Array<Gitlab::ObjectifiedHash>]
    def dockerfile_templates
      get('/templates/dockerfiles')
    end

    # Get a single Dockerfile template.
    #
    # @example
    #   Gitlab.dockerfile_template('Binary')
    #
    # @param  [String] key The key of the Dockerfile template
    # @return [Gitlab::ObjectifiedHash]
    def dockerfile_template(key)
      get("/templates/dockerfiles/#{key}")
    end
  end
end
