# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to project approval settings.
  # Does not exist in API documentation
  module ApprovalSettings
    # Gets a the approval settings for a Project
    #
    # @example
    #   Gitlab.approval_settings_for_project(1)
    #   Gitlab.approval_settings_for_project("project")
    #
    # @param  [Integer, String] id The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def approval_settings_for_project(project)
      get("/projects/#{url_encode project}/approval_settings")
    end
  end
end
