# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to resource state events.
  # @see https://docs.gitlab.com/ee/api/resource_state_events.html
  module ResourceStateEvents
    # Gets a list of all state events for a single issue.
    #
    # @example
    #   Gitlab.issue_state_events(5, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] issue_iid The IID of an issue.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def issue_state_events(project, issue_iid)
      get("/projects/#{url_encode project}/issues/#{issue_iid}/resource_state_events")
    end

    # Returns a single state event for a specific project issue
    #
    # @example
    #   Gitlab.issue_state_event(5, 42, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] issue_iid The IID of an issue.
    # @param  [Integer] id The ID of a resource event.
    # @return Gitlab::ObjectifiedHash
    def issue_state_event(project, issue_iid, id)
      get("/projects/#{url_encode project}/issues/#{issue_iid}/resource_state_events/#{id}")
    end

    # Gets a list of all state events for a single merge request.
    #
    # @example
    #   Gitlab.merge_request_state_events(5, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] merge_request_iid The IID of a merge request.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def merge_request_state_events(project, merge_request_iid)
      get("/projects/#{url_encode project}/merge_requests/#{merge_request_iid}/resource_state_events")
    end

    # Returns a single state event for a specific project merge request
    #
    # @example
    #   Gitlab.merge_request_state_event(5, 42, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] merge_request_iid The IID of an merge request.
    # @param  [Integer] id The ID of a state event.
    # @return Gitlab::ObjectifiedHash
    def merge_request_state_event(project, merge_request_iid, id)
      get("/projects/#{url_encode project}/merge_requests/#{merge_request_iid}/resource_state_events/#{id}")
    end
  end
end
