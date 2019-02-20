# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to merge requests.
  # @see https://docs.gitlab.com/ce/api/merge_requests.html
  module MergeRequests
    # Gets a list of all of the merge requests the authenticated user has access to.
    #
    # @example
    #   Gitlab.user_merge_requests
    #   Gitlab.user_merge_requests(state: :opened, scope: :all)
    #
    # @param  [Hash] options A customizable set of options.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def user_merge_requests(options = {})
      get('/merge_requests', query: options)
    end

    # Gets a list of project merge requests.
    #
    # @example
    #   Gitlab.merge_requests(5)
    #   Gitlab.merge_requests(5, { per_page: 40 })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def merge_requests(project, options = {})
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

    # Gets a list of merge request pipelines.
    #
    # @example
    #   Gitlab.merge_request_pipelines(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def merge_request_pipelines(project, id)
      get("/projects/#{url_encode project}/merge_requests/#{id}/pipelines")
    end

    # Get a list of merge request participants.
    #
    # @example
    #   Gitlab.merge_request_participants(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def merge_request_participants(project, id)
      get("/projects/#{url_encode project}/merge_requests/#{id}/participants")
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
    def create_merge_request(project, title, options = {})
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
    def update_merge_request(project, id, options = {})
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
    def accept_merge_request(project, id, options = {})
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

    # List project merge request discussions
    #
    # @example
    #   Gitlab.merge_request_discussions(5, 1)
    #   Gitlab.merge_request_discussions('gitlab', 1)
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @return [Gitlab::ObjectifiedHash] List of the merge request discussions.
    def merge_request_discussions(project, merge_request_id)
      get("/projects/#{url_encode project}/merge_requests/#{merge_request_id}/discussions")
    end

    # Get single merge request discussion
    #
    # @example
    #   Gitlab.merge_request_discussion(5, 1, 1)
    #   Gitlab.merge_request_discussion('gitlab', 1, 1)
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @param  [Integer] discussion_id The ID of a discussion.
    # @return [Gitlab::ObjectifiedHash] The merge request discussion.
    def merge_request_discussion(project, merge_request_id, discussion_id)
      get("/projects/#{url_encode project}/merge_requests/#{merge_request_id}/discussions/#{discussion_id}")
    end

    # Create new merge request discussion
    #
    # @example
    #   Gitlab.create_merge_request_discussion(5, 1, body: 'discuss')
    #   Gitlab.create_merge_request_discussion('gitlab', 1, body: 'discuss')
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @param  [Hash] options A customizable set of options.
    #   * :body (String) The content of a discussion
    #   * :created_at (String) Date time string, ISO 8601 formatted, e.g. 2016-03-11T03:45:40Z
    #   * :position (Hash) Position when creating a diff note
    #     * :base_sha (String) Base commit SHA in the source branch
    #     * :start_sha (String) SHA referencing commit in target branch
    #     * :head_sha (String) SHA referencing HEAD of this merge request
    #     * :position_type (String) Type of the position reference', allowed values: 'text' or 'image'
    #     * :new_path (String) File path after change
    #     * :new_line (Integer) Line number after change (for 'text' diff notes)
    #     * :old_path (String) File path before change
    #     * :old_line (Integer) Line number before change (for 'text' diff notes)
    #     * :width (Integer) Width of the image (for 'image' diff notes)
    #     * :height (Integer) Height of the image (for 'image' diff notes)
    #     * :x (Integer) X coordinate (for 'image' diff notes)
    #     * :y (Integer) Y coordinate (for 'image' diff notes)
    # @return [Gitlab::ObjectifiedHash] The created merge request discussion.
    def create_merge_request_discussion(project, merge_request_id, options = {})
      post("/projects/#{url_encode project}/merge_requests/#{merge_request_id}/discussions", body: options)
    end

    # Resolve a merge request discussion
    #
    # @example
    #   Gitlab.resolve_merge_request_discussion(5, 1, 1, true)
    #   Gitlab.resolve_merge_request_discussion('gitlab', 1, 1, false)
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @param  [Integer] discussion_id The ID of a discussion.
    # @param  [Hash] options A customizable set of options.
    # @option options [Boolean] :resolved Resolve/unresolve the discussion.
    # @return [Gitlab::ObjectifiedHash] The merge request discussion.
    def resolve_merge_request_discussion(project, merge_request_id, discussion_id, options)
      put("/projects/#{url_encode project}/merge_requests/#{merge_request_id}/discussions/#{discussion_id}", body: options)
    end

    # Add note to existing merge request discussion
    #
    # @example
    #   Gitlab.create_merge_request_discussion_note(5, 1, 1, note_id: 1, body: 'note')
    #   Gitlab.create_merge_request_discussion_note('gitlab', 1, 1, note_id: 1, body: 'note')
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @param  [Integer] discussion_id The ID of a discussion.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :note_id The ID of a discussion note.
    # @option options [String] :body The content of a discussion.
    # @option options [String] :created_at Date time string, ISO 8601 formatted, e.g. 2016-03-11T03:45:40Z.
    # @return [Gitlab::ObjectifiedHash] The merge request discussion note.
    def create_merge_request_discussion_note(project, merge_request_id, discussion_id, options)
      post("/projects/#{url_encode project}/merge_requests/#{merge_request_id}/discussions/#{discussion_id}/notes", body: options)
    end

    # Modify an existing merge request discussion note
    #
    # @example
    #   Gitlab.update_merge_request_discussion_note(5, 1, 1, 1, body: 'note')
    #   Gitlab.update_merge_request_discussion_note('gitlab', 1, 1, 1, body: 'note')
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @param  [Integer] discussion_id The ID of a discussion.
    # @param  [Integer] note_id The ID of a discussion note.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :body The content of a discussion.
    # @option options [Boolean] :resolved Resolve/unresolve the note.
    # @return [Gitlab::ObjectifiedHash] The merge request discussion note.
    def update_merge_request_discussion_note(project, merge_request_id, discussion_id, note_id, options)
      put("/projects/#{url_encode project}/merge_requests/#{merge_request_id}/discussions/#{discussion_id}/notes/#{note_id}", body: options)
    end

    # Delete a merge request discussion note
    #
    # @example
    #   Gitlab.delete_merge_request_discussion_note(5, 1, 1, 1)
    #   Gitlab.delete_merge_request_discussion_note('gitlab', 1, 1, 1)
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @param  [Integer] discussion_id The ID of a discussion.
    # @param  [Integer] note_id The ID of a discussion note.
    # @return [Gitlab::ObjectifiedHash] An empty response.
    def delete_merge_request_discussion_note(project, merge_request_id, discussion_id, note_id)
      delete("/projects/#{url_encode project}/merge_requests/#{merge_request_id}/discussions/#{discussion_id}/notes/#{note_id}")
    end

    # Gets a list of merge request diff versions
    #
    # @example
    #   Gitlab.merge_request_versions(5, 1)
    #   Gitlab.merge_request_versions('gitlab', 1)
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @return [Gitlab::ObjectifiedHash] A list of the merge request versions.
    def merge_request_diff_versions(project, merge_request_id)
      get("/projects/#{url_encode project}/merge_requests/#{merge_request_id}/versions")
    end

    # Gets the diff a single merge request diff version\
    #
    # @example
    #   Gitlab.merge_request_diff_version(5, 1, 1)
    #   Gitlab.merge_request_diff_version('gitlab', 1, 1)
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @param  [Integer] id The ID of a merge request diff version.
    # @return [Gitlab::ObjectifiedHash] Record of the specific diff
    def merge_request_diff_version(project, merge_request_id, version_id)
      get("/projects/#{url_encode project}/merge_requests/#{merge_request_id}/versions/#{version_id}")
    end
  end
end
