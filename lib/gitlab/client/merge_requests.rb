class Gitlab::Client
  # Defines methods related to merge requests.
  # @see https://docs.gitlab.com/ce/api/merge_requests.html
  module MergeRequests
    # Gets a list of project merge requests.
    #
    # @example
    #   Gitlab.merge_requests(5)
    #   Gitlab.merge_requests({ per_page: 40 })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def merge_requests(project, options={})
      get("/projects/#{url_encode project}/merge_requests", query: options)
    end

    # Gets a single merge request.
    #
    # @example
    #   Gitlab.merge_request(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @return <Gitlab::ObjectifiedHash]
    def merge_request(project, id)
      get("/projects/#{url_encode project}/merge_requests/#{id}")
    end

    # Creates a merge request.
    #
    # @example
    #   Gitlab.create_merge_request(5, 'New merge request',
    #     { source_branch: 'source_branch', target_branch: 'target_branch' })
    #   Gitlab.create_merge_request(5, 'New merge request',
    #     { source_branch: 'source_branch', target_branch: 'target_branch', assignee_id: 42 })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] title The title of a merge request.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :source_branch (required) The source branch name.
    # @option options [String] :target_branch (required) The target branch name.
    # @option options [Integer] :assignee_id (optional) The ID of a user to assign merge request.
    # @option options [Integer] :target_project_id (optional) The target project ID.
    # @option options [String] :labels (optional) Labels as a comma-separated list.
    # @return [Gitlab::ObjectifiedHash] Information about created merge request.
    def create_merge_request(project, title, options={})
      body = { title: title }.merge(options)
      post("/projects/#{url_encode project}/merge_requests", body: body)
    end

    # Updates a merge request.
    #
    # @example
    #   Gitlab.update_merge_request(5, 42, { title: 'New title' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title The title of a merge request.
    # @option options [String] :source_branch The source branch name.
    # @option options [String] :target_branch The target branch name.
    # @option options [Integer] :assignee_id The ID of a user to assign merge request.
    # @option options [String] :state_event New state (close|reopen|merge).
    # @return [Gitlab::ObjectifiedHash] Information about updated merge request.
    def update_merge_request(project, id, options={})
      put("/projects/#{url_encode project}/merge_requests/#{id}", body: options)
    end

    # Accepts a merge request.
    #
    # @example
    #   Gitlab.accept_merge_request(5, 42, { merge_commit_message: 'Nice!' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :merge_commit_message Custom merge commit message
    # @return [Gitlab::ObjectifiedHash] Information about updated merge request.
    def accept_merge_request(project, id, options={})
      put("/projects/#{url_encode project}/merge_requests/#{id}/merge", body: options)
    end

    # Gets the changes of a merge request.
    #
    # @example
    #   Gitlab.merge_request_changes(5, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @return [Gitlab::ObjectifiedHash] The merge request's changes.
    def merge_request_changes(project, id)
      get("/projects/#{url_encode project}/merge_requests/#{id}/changes")
    end

    # Gets the commits of a merge request.
    #
    # @example
    #   Gitlab.merge_request_commits(5, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @return [Array<Gitlab::ObjectifiedHash>] The merge request's commits.
    def merge_request_commits(project, id)
      get("/projects/#{url_encode project}/merge_requests/#{id}/commits")
    end

    # List issues that will close on merge
    #
    # @example
    #   Gitlab.merge_request_closes_issues(5, 1)
    #
    # @param [Integer] project The ID of a project
    # @param [Integer] iid The internal ID of a merge request
    def merge_request_closes_issues(project_id, merge_request_iid)
      get("/projects/#{project_id}/merge_requests/#{merge_request_iid}/closes_issues")
    end

    # Subscribes to a merge request.
    #
    # @example
    #   Gitlab.subscribe_to_merge_request(5, 1)
    #   Gitlab.subscribe_to_merge_request('gitlab', 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @return [Gitlab::ObjectifiedHash] Information about subscribed merge request.
    def subscribe_to_merge_request(project, id)
      post("/projects/#{url_encode project}/merge_requests/#{id}/subscribe")
    end

    # Unsubscribes from a merge request.
    #
    # @example
    #   Gitlab.unsubscribe_from_merge_request(5, 1)
    #   Gitlab.unsubscribe_from_merge_request('gitlab', 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @return [Gitlab::ObjectifiedHash] Information about unsubscribed merge request.
    def unsubscribe_from_merge_request(project, id)
      post("/projects/#{url_encode project}/merge_requests/#{id}/unsubscribe")
    end
  end
end
