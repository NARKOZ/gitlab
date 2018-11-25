# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to gitignore templates.
  # @see https://docs.gitlab.com/ce/api/templates/gitignores.html
  module GitignoreTemplates
    # Get all gitignore templates.
    #
    # @example
    #   Gitlab.gitignore_templates
    #
    # @return [Array<Gitlab::ObjectifiedHash>]
    def gitignore_templates
      get('/templates/gitignores')
    end

    # Get a single gitignore template.
    #
    # @example
    #   Gitlab.gitignore_template('Ruby')
    #
    # @param  [String] key The key of the gitignore template
    # @return [Gitlab::ObjectifiedHash]
    def gitignore_template(key)
      get("/templates/gitignores/#{key}")
    end
  end
end
