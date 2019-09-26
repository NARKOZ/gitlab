# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to issue links.
  # @see https://docs.gitlab.com/ee/api/issue_links.html
  module IssueLinks
    # Gets a list of links for a issue.
    #
    # @example
    #   Gitlab.issue_links(5, 10)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] issue The ID of an issue.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def issue_links(project, issue, options = {})
      get("/projects/#{url_encode project}/issues/#{issue}/links", query: options)
    end

    # Creates a new issue link.
    #
    # @example
    #   Gitlab.create_issue_link(6, 1, 6, 2)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] issue The ID of an issue.
    # @param  [Integer] target_project_id Project ID the target issue is located in.
    # @param  [Integer] target_issue_iid The ID of the target issue.
    # @return [Gitlab::ObjectifiedHash] Information about created link.
    def create_issue_link(project, issue, target_project_id, target_issue_iid)
      post("/projects/#{url_encode project}/issues/#{issue}/links", body: { target_project_id: target_project_id, target_issue_iid: target_issue_iid })
    end

    # Deletes an issue link.
    #
    # @example
    #   Gitlab.delete_issue_link(5, 10, 123)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] issue The ID of an issue.
    # @param [Integer] id The ID of a link.
    # @return [Gitlab::ObjectifiedHash]
    def delete_issue_link(project, issue, id)
      delete("/projects/#{url_encode project}/issues/#{issue}/links/#{id}")
    end
  end
end
