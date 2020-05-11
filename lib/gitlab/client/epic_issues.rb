# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to issues.
  # @see https://docs.gitlab.com/ee/api/epic_issues.html
  module EpicIssues
    # List issues for an epic.
    # Gets all issues that are assigned to an epic and the authenticated user has access to..
    # @example
    #   Gitlab.epic_issues(5, 7)
    #   Gitlab.epic_issues(5, 7, { per_page: 40 })
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer] epic The iid of an epic.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def epic_issues(group, epic, options = {})
      get("/groups/#{url_encode group}/epics/#{epic}/issues", query: options)
    end
  end
end
