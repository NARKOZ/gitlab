# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to Award Emojis.
  # @see https://docs.gitlab.com/ce/api/access_requests.html
  module AccessRequests
    # Gets a list of access requests for a project viewable by the authenticated user.
    #
    # @example
    #   Gitlab.project_access_requests(1)
    #
    # @param  [Integer, String] :project(required) The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>] List of project access requests
    def project_access_requests(project)
      get("/projects/#{url_encode project}/access_requests")
    end

    # Gets a list of access requests for a group viewable by the authenticated user.
    #
    # @example
    #   Gitlab.group_access_requests(1)
    #
    # @param  [Integer, String] :group(required) The ID or name of a group.
    # @return [Array<Gitlab::ObjectifiedHash>] List of group access requests
    def group_access_requests(group)
      get("/groups/#{url_encode group}/access_requests")
    end

    # Requests access for the authenticated user to a project.
    #
    # @example
    #    Gitlab.request_project_access(1)
    #
    # @param  [Integer, String] :project(required) The ID or name of a project.
    # @return <Gitlab::ObjectifiedHash] Information about the requested project access
    def request_project_access(project)
      post("/projects/#{url_encode project}/access_requests")
    end

    # Requests access for the authenticated user to a group.
    #
    # @example
    #    Gitlab.request_group_access(1)
    #
    # @param  [Integer, String] :group(required) The ID or name of a group.
    # @return <Gitlab::ObjectifiedHash] Information about the requested group access
    def request_group_access(group)
      post("/groups/#{url_encode group}/access_requests")
    end

    # Approves a project access request for the given user.
    #
    # @example
    #    Gitlab.approve_project_access_request(1, 1)
    #    Gitlab.approve_project_access_request(1, 1, {access_level: '30'})
    #
    # @param  [Integer, String] :project(required) The ID or name of a project.
    # @param  [Integer] :user_id(required) The user ID of the access requester
    # @option options [Integer] :access_level(optional) A valid access level (defaults: 30, developer access level)
    # @return <Gitlab::ObjectifiedHash] Information about the approved project access request
    def approve_project_access_request(project, user_id, options = {})
      put("/projects/#{url_encode project}/access_requests/#{user_id}/approve", body: options)
    end

    # Approves a group access request for the given user.
    #
    # @example
    #    Gitlab.approve_group_access_request(1, 1)
    #    Gitlab.approve_group_access_request(1, 1, {access_level: '30'})
    #
    # @param  [Integer, String] :group(required) The ID or name of a group.
    # @param  [Integer] :user_id(required) The user ID of the access requester
    # @option options [Integer] :access_level(optional) A valid access level (defaults: 30, developer access level)
    # @return <Gitlab::ObjectifiedHash] Information about the approved group access request
    def approve_group_access_request(group, user_id, options = {})
      put("/groups/#{url_encode group}/access_requests/#{user_id}/approve", body: options)
    end

    # Denies a project access request for the given user.
    #
    # @example
    #    Gitlab.deny_project_access_request(1, 1)
    #
    # @param  [Integer, String] :project(required) The ID or name of a project.
    # @param  [Integer] :user_id(required) The user ID of the access requester
    # @return [void] This API call returns an empty response body.
    def deny_project_access_request(project, user_id)
      delete("/projects/#{url_encode project}/access_requests/#{user_id}")
    end

    # Denies a group access request for the given user.
    #
    # @example
    #    Gitlab.deny_group_access_request(1, 1)
    #
    # @param  [Integer, String] :group(required) The ID or name of a group.
    # @param  [Integer] :user_id(required) The user ID of the access requester
    # @return [void] This API call returns an empty response body.
    def deny_group_access_request(group, user_id)
      delete("/groups/#{url_encode group}/access_requests/#{user_id}")
    end
  end
end
