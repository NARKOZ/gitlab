# frozen_string_literal: true

class Gitlab::Client
  # Third party services connected to a project.
  # @see https://docs.gitlab.com/ce/api/services.html
  module Services
    # Create/Edit service
    # Full service params documentation: https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/services.md
    #
    # @example
    #   Gitlab.change_service(42, :redmine, { new_issue_url: 'https://example.com/projects/test_project/issues/new',
    #                                         project_url: 'https://example.com/projects/test_project/issues',
    #                                         issues_url: 'https://example.com/issues/:id' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] service A service code name.
    # @param  [Hash] params A service parameters.
    # @return [Boolean]
    def change_service(project, service, params)
      put("/projects/#{url_encode project}/services/#{correct_service_name(service)}", body: params)
    end

    # Delete service
    #
    # @example
    #   Gitlab.delete_service(42, :redmine)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] service A service code name.
    # @return [Boolean]
    def delete_service(project, service)
      delete("/projects/#{url_encode project}/services/#{correct_service_name(service)}")
    end

    # Get service
    #
    # @example
    #   Gitlab.service(42, :redmine)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] service A service code name.
    # @return [Gitlab::ObjectifiedHash]
    def service(project, service)
      get("/projects/#{url_encode project}/services/#{correct_service_name(service)}")
    end

    private

    def correct_service_name(service)
      service.to_s.tr('_', '-')
    end
  end
end
