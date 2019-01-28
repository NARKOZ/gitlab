# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to resource label events.
  # @see https://docs.gitlab.com/ee/api/resource_label_events.html
  module ResourceLabelEvents
    # Gets a list of all label events for a single issue.
    #
    # @example
    #   Gitlab.issue_label_events(5, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] issue_iid The IID of an issue.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def issue_label_events(project, issue_iid)
      get("/projects/#{url_encode project}/issues/#{issue_iid}/resource_label_events")
    end

    # Returns a single label event for a specific project issue
    #
    # @example
    #   Gitlab.issue_label_event(5, 42, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] issue_iid The IID of an issue.
    # @param  [Integer] id The ID of a label event.
    # @return Gitlab::ObjectifiedHash
    def issue_label_event(project, issue_iid, id)
      get("/projects/#{url_encode project}/issues/#{issue_iid}/resource_label_events/#{id}")
    end

    # Gets a list of all label events for a single epic.
    #
    # @example
    #   Gitlab.epic_label_events(5, 42)
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer] epic_id The ID of an epic.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def epic_label_events(group, epic_id)
      get("/groups/#{url_encode group}/epics/#{epic_id}/resource_label_events")
    end

    # Returns a single label event for a specific group epic
    #
    # @example
    #   Gitlab.epic_label_event(5, 42, 1)
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer] epic_id The ID of an epic.
    # @param  [Integer] id The ID of a label event.
    # @return Gitlab::ObjectifiedHash
    def epic_label_event(group, epic_id, id)
      get("/groups/#{url_encode group}/epics/#{epic_id}/resource_label_events/#{id}")
    end

    # Gets a list of all label events for a single merge request.
    #
    # @example
    #   Gitlab.merge_request_label_events(5, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] merge_request_iid The IID of a merge request.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def merge_request_label_events(project, merge_request_iid)
      get("/projects/#{url_encode project}/merge_requests/#{merge_request_iid}/resource_label_events")
    end

    # Returns a single label event for a specific project merge request
    #
    # @example
    #   Gitlab.merge_request_label_event(5, 42, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] merge_request_iid The IID of an merge request.
    # @param  [Integer] id The ID of a label event.
    # @return Gitlab::ObjectifiedHash
    def merge_request_label_event(project, merge_request_iid, id)
      get("/projects/#{url_encode project}/merge_requests/#{merge_request_iid}/resource_label_events/#{id}")
    end
  end
end
