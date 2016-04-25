class Gitlab::Client
  # Defines methods related to issues.
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/issues.md
  module Issues
    # Gets a list of user's issues.
    # Will return a list of project's issues if project ID passed.
    #
    # @example
    #   Gitlab.issues
    #   Gitlab.issues(5)
    #   Gitlab.issues({ per_page: 40 })
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def issues(project=nil, options={})
      if project.to_i.zero?
        get("/issues", query: options)
      else
        get("/projects/#{project}/issues", query: options)
      end
    end

    # Gets a single issue.
    #
    # @example
    #   Gitlab.issue(5, 42)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] id The ID of an issue.
    # @return [Gitlab::ObjectifiedHash]
    def issue(project, id)
      get("/projects/#{project}/issues/#{id}")
    end

    # Creates a new issue.
    #
    # @example
    #   Gitlab.create_issue(5, 'New issue')
    #   Gitlab.create_issue(5, 'New issue', { description: 'This is a new issue', assignee_id: 42 })
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] title The title of an issue.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description The description of an issue.
    # @option options [Integer] :assignee_id The ID of a user to assign issue.
    # @option options [Integer] :milestone_id The ID of a milestone to assign issue.
    # @option options [String] :labels Comma-separated label names for an issue.
    # @return [Gitlab::ObjectifiedHash] Information about created issue.
    def create_issue(project, title, options={})
      body = { title: title }.merge(options)
      post("/projects/#{project}/issues", body: body)
    end

    # Updates an issue.
    #
    # @example
    #   Gitlab.edit_issue(6, 1, { title: 'Updated title' })
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] id The ID of an issue.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title The title of an issue.
    # @option options [String] :description The description of an issue.
    # @option options [Integer] :assignee_id The ID of a user to assign issue.
    # @option options [Integer] :milestone_id The ID of a milestone to assign issue.
    # @option options [String] :labels Comma-separated label names for an issue.
    # @option options [String] :state_event The state event of an issue ('close' or 'reopen').
    # @return [Gitlab::ObjectifiedHash] Information about updated issue.
    def edit_issue(project, id, options={})
      put("/projects/#{project}/issues/#{id}", body: options)
    end

    # Closes an issue.
    #
    # @example
    #   Gitlab.close_issue(3, 42)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] id The ID of an issue.
    # @return [Gitlab::ObjectifiedHash] Information about closed issue.
    def close_issue(project, id)
      put("/projects/#{project}/issues/#{id}", body: { state_event: 'close' })
    end

    # Reopens an issue.
    #
    # @example
    #   Gitlab.reopen_issue(3, 42)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] id The ID of an issue.
    # @return [Gitlab::ObjectifiedHash] Information about reopened issue.
    def reopen_issue(project, id)
      put("/projects/#{project}/issues/#{id}", body: { state_event: 'reopen' })
    end

    # Deletes  an issue.
    # Only for admins and project owners
    #
    # @example
    #   Gitlab.delete_issue(3, 42)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] id The ID of an issue.
    # @return [Gitlab::ObjectifiedHash] Information about deleted issue.
    def delete_issue(project, id)
      delete("/projects/#{project}/issues/#{id}")
    end
  end
end
