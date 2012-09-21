class Gitlab::Client
  # Defines methods related to issues.
  module Issues
    # Gets a list of user's issues.
    # Will return a list of project's issues if project ID or code name passed.
    #
    # @example
    #   Gitlab.issues
    #   Gitlab.issues(5)
    #   Gitlab.issues('gitlab', :per_page => 40)
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def issues(project=nil, options={})
      if project.to_i.zero?
        get("/issues", :query => options)
      else
        get("/projects/#{project}/issues", :query => options)
      end
    end

    # Gets a single issue.
    #
    # @example
    #   Gitlab.issue(5, 36)
    #   Gitlab.issue('gitlab', 42)
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Integer] id The ID of an issue.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def issue(project, id)
      get("/projects/#{project}/issues/#{id}")
    end

    # Creates a new issue.
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [String] title The title of an issue.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description The description of an issue.
    # @option options [Integer] :assignee_id The ID of a user to assign issue.
    # @option options [Integer] :milestone_id The ID of a milestone to assign issue.
    # @option options [String] :labels Comma-separated label names for an issue.
    # @return [Gitlab::ObjectifiedHash] Information about created issue.
    def create_issue(project, title, options={})
      body = {:title => title}.merge(options)
      post("/projects/#{project}/issues", :body => body)
    end

    # Updates an issue.
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Integer] id The ID of an issue.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title The title of an issue.
    # @option options [String] :description The description of an issue.
    # @option options [Integer] :assignee_id The ID of a user to assign issue.
    # @option options [Integer] :milestone_id The ID of a milestone to assign issue.
    # @option options [String] :labels Comma-separated label names for an issue.
    # @option options [Boolean] :closed The state of an issue (0 = false, 1 = true).
    # @return [Gitlab::ObjectifiedHash] Information about updated issue.
    def edit_issue(project, id, options={})
      put("/projects/#{project}/issues/#{id}", :body => options)
    end
  end
end
