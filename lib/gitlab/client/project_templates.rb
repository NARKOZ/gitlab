# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to project-specific templates.
  # @see https://docs.gitlab.com/ce/api/projects.html
  module ProjectTemplates
    # Get all templates of a particular type
    # @example
    #   Gitlab.project_templates(1, 'dockerfiles')
    #   Gitlab.project_templates(1, 'licenses')
    #
    # @param  [Integer, String] id The ID or URL-encoded path of the project.
    # @param  [String] type The type (dockerfiles|gitignores|gitlab_ci_ymls|licenses) of the template
    # @return [Array<Gitlab::ObjectifiedHash>]
    def project_templates(project, type)
      get("/projects/#{url_encode project}/templates/#{type}")
    end

    # Get one template of a particular type
    #
    # @example
    #   Gitlab.project_template(1, 'dockerfiles', 'dockey')
    #   Gitlab.project_template(1, 'licenses', 'gpl', { project: 'some project', fullname: 'Holder Holding' })
    #
    # @param  [Integer, String] project The ID or URL-encoded path of the project.
    # @param  [String] type The type (dockerfiles|gitignores|gitlab_ci_ymls|licenses) of the template
    # @param  [String] key The key of the template, as obtained from the collection endpoint
    # @param  [Hash] options A customizable set of options.
    # @option options [String] project(optional) The project name to use when expanding placeholders in the template. Only affects licenses
    # @option options [String] fullname(optional) The full name of the copyright holder to use when expanding placeholders in the template. Only affects licenses
    # @return [Gitlab::ObjectifiedHash]
    def project_template(project, type, key, options = {})
      get("/projects/#{url_encode project}/templates/#{type}/#{key}", query: options)
    end
  end
end
