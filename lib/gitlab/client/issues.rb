# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to issues.
  # @see https://docs.gitlab.com/ce/api/issues.html
  module Issues
    # Gets a list of user's issues.
    # Will return a list of project's issues if project ID passed.
    #
    # @example
    #   Gitlab.issues
    #   Gitlab.issues(5)
    #   Gitlab.issues({ per_page: 40 })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def issues(project = nil, options = {})
      if project.to_s.empty? && project.to_i.zero?
        get('/issues', query: options)
      else
        get("/projects/#{url_encode project}/issues", query: options)
      end
    end

    # Gets a single issue.
    #
    # @example
    #   Gitlab.issue(5, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    # @return [Gitlab::ObjectifiedHash]
    def issue(project, id)
      get("/projects/#{url_encode project}/issues/#{id}")
    end

    # Creates a new issue.
    #
    # @example
    #   Gitlab.create_issue(5, 'New issue')
    #   Gitlab.create_issue(5, 'New issue', { description: 'This is a new issue', assignee_id: 42 })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] title The title of an issue.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description The description of an issue.
    # @option options [Integer] :assignee_id The ID of a user to assign issue.
    # @option options [Integer] :milestone_id The ID of a milestone to assign issue.
    # @option options [String] :labels Comma-separated label names for an issue.
    # @return [Gitlab::ObjectifiedHash] Information about created issue.
    def create_issue(project, title, options = {})
      body = { title: title }.merge(options)
      post("/projects/#{url_encode project}/issues", body: body)
    end

    # Updates an issue.
    #
    # @example
    #   Gitlab.edit_issue(6, 1, { title: 'Updated title' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title The title of an issue.
    # @option options [String] :description The description of an issue.
    # @option options [Integer] :assignee_id The ID of a user to assign issue.
    # @option options [Integer] :milestone_id The ID of a milestone to assign issue.
    # @option options [String] :labels Comma-separated label names for an issue.
    # @option options [String] :state_event The state event of an issue ('close' or 'reopen').
    # @return [Gitlab::ObjectifiedHash] Information about updated issue.
    def edit_issue(project, id, options = {})
      put("/projects/#{url_encode project}/issues/#{id}", body: options)
    end

    # Closes an issue.
    #
    # @example
    #   Gitlab.close_issue(3, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    # @return [Gitlab::ObjectifiedHash] Information about closed issue.
    def close_issue(project, id)
      put("/projects/#{url_encode project}/issues/#{id}", body: { state_event: 'close' })
    end

    # Reopens an issue.
    #
    # @example
    #   Gitlab.reopen_issue(3, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    # @return [Gitlab::ObjectifiedHash] Information about reopened issue.
    def reopen_issue(project, id)
      put("/projects/#{url_encode project}/issues/#{id}", body: { state_event: 'reopen' })
    end

    # Subscribe to an issue.
    #
    # @example
    #   Gitlab.subscribe_to_issue(3, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    # @return [Gitlab::ObjectifiedHash] Information about subscribed issue.
    def subscribe_to_issue(project, id)
      post("/projects/#{url_encode project}/issues/#{id}/subscribe")
    end

    # Unsubscribe from an issue.
    #
    # @example
    #   Gitlab.unsubscribe_from_issue(3, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    # @return [Gitlab::ObjectifiedHash] Information about unsubscribed issue.
    def unsubscribe_from_issue(project, id)
      post("/projects/#{url_encode project}/issues/#{id}/unsubscribe")
    end

    # Deletes  an issue.
    # Only for admins and project owners
    #
    # @example
    #   Gitlab.delete_issue(3, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    # @return [Gitlab::ObjectifiedHash] Information about deleted issue.
    def delete_issue(project, id)
      delete("/projects/#{url_encode project}/issues/#{id}")
    end

    # Move an issue.
    #
    # @example
    #   Gitlab.move_issue(3, 42, { to_project_id: '4' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    # @option options [String] :to_project_id The ID of the new project.
    # @return [Gitlab::ObjectifiedHash] Information about moved issue.
    def move_issue(project, id, options = {})
      post("/projects/#{url_encode project}/issues/#{id}/move", body: options)
    end

    # Sets an estimated time of work for an issue.
    #
    # @example
    #   Gitlab.estimate_time_of_issue(3, 42, '3h30m')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    # @param  [String] duration The duration in human format. e.g: 3h30m
    def estimate_time_of_issue(project, id, duration)
      post("/projects/#{url_encode project}/issues/#{id}/time_estimate", body: { duration: url_encode(duration) })
    end

    # Resets the estimated time for an issue to 0 seconds.
    #
    # @example
    #   Gitlab.reset_time_estimate_of_issue(3, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    def reset_time_estimate_of_issue(project, id)
      post("/projects/#{url_encode project}/issues/#{id}/reset_time_estimate")
    end

    # Adds spent time for an issue
    #
    # @example
    #   Gitlab.estimate_time_of_issue(3, 42, '3h30m')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    # @param  [String] duration The time spent in human format. e.g: 3h30m
    def add_time_spent_on_issue(project, id, duration)
      post("/projects/#{url_encode project}/issues/#{id}/add_spent_time", body: { duration: duration })
    end

    # Resets the total spent time for this issue to 0 seconds.
    #
    # @example
    #   Gitlab.reset_time_spent_on_issue(3, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    def reset_time_spent_on_issue(project, id)
      post("/projects/#{url_encode project}/issues/#{id}/reset_spent_time")
    end

    # Get time tracking stats for an issue
    #
    # @example
    #   @gitlab.time_stats_for_issue(3, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    def time_stats_for_issue(project, id)
      get("/projects/#{url_encode project}/issues/#{id}/time_stats")
    end

    # Get participants on issue
    #
    # @example
    #   @gitlab.participants_on_issue(3, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    def participants_on_issue(project, id)
      get("/projects/#{url_encode project}/issues/#{id}/participants")
    end

    # List merge requests that will close issue on merge
    #
    # @example
    #   Gitlab.merge_requests_closing_issue_on_merge(3, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an issue.
    def merge_requests_closing_issue_on_merge(project, id)
      get("/projects/#{url_encode project}/issues/#{id}/closed_by")
    end
  end
end
