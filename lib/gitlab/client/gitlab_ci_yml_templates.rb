# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to gitlab_ci.yml templates.
  # @see https://docs.gitlab.com/ce/api/templates/gitlab_ci_ymls.html
  module GitlabCiYmlTemplates
    # Get all gitlab_ci_yml templates.
    #
    # @example
    #   Gitlab.gitlab_ci_yml_templates
    #
    # @return [Array<Gitlab::ObjectifiedHash>]
    def gitlab_ci_yml_templates
      get('/templates/gitlab_ci_ymls')
    end

    # Get a single gitlab_ci_yml template.
    #
    # @example
    #   Gitlab.gitlab_ci_yml_template('Ruby')
    #
    # @param  [String] key The key of the gitlab_ci_yml template
    # @return [Gitlab::ObjectifiedHash]
    def gitlab_ci_yml_template(key)
      get("/templates/gitlab_ci_ymls/#{key}")
    end
  end
end
