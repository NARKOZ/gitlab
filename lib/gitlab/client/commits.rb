class Gitlab::Client
  # Defines methods related to repository commits.
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/commits.md
  module Commits
    # Gets a list of project commits.
    #
    # @example
    #   Gitlab.commits('viking')
    #   Gitlab.repo_commits('gitlab', { ref_name: 'api' })
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :ref_name The branch or tag name of a project repository.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def commits(project, options={})
      get("/projects/#{project}/repository/commits", query: options)
    end
    alias_method :repo_commits, :commits

    # Gets a specific commit identified by the commit hash or name of a branch or tag.
    #
    # @example
    #   Gitlab.commit(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #   Gitlab.repo_commit(3, 'ed899a2f4b50b4370feeea94676502b42383c746')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] sha The commit hash or name of a repository branch or tag
    # @return [Gitlab::ObjectifiedHash]
    def commit(project, sha)
      get("/projects/#{project}/repository/commits/#{sha}")
    end
    alias_method :repo_commit, :commit

    # Get the diff of a commit in a project.
    #
    # @example
    #   Gitlab.commit_diff(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #   Gitlab.repo_commit_diff(3, 'ed899a2f4b50b4370feeea94676502b42383c746')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] sha The name of a repository branch or tag or if not given the default branch.
    # @return [Gitlab::ObjectifiedHash]
    def commit_diff(project, sha)
      get("/projects/#{project}/repository/commits/#{sha}/diff")
    end
    alias_method :repo_commit_diff, :commit_diff

    # Gets a list of comments for a commit.
    #
    # @example
    #   Gitlab.commit_comments(5, 'c9f9662a9b1116c838b523ed64c6abdb4aae4b8b')
    #
    # @param [Integer] project The ID of a project.
    # @param [String] sha The commit hash or name of a repository branch or tag.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def commit_comments(project, commit, options={})
      get("/projects/#{project}/repository/commits/#{commit}/comments", query: options)
    end
    alias_method :repo_commit_comments, :commit_comments

    # Creates a new comment for a commit.
    #
    # @example
    #   Gitlab.create_commit_comment(5, 'c9f9662a9b1116c838b523ed64c6abdb4aae4b8b', 'Nice work on this commit!')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] sha The commit hash or name of a repository branch or tag.
    # @param  [String] note The text of a comment.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :path The file path.
    # @option options [Integer] :line The line number.
    # @option options [String] :line_type The line type (new or old).
    # @return [Gitlab::ObjectifiedHash] Information about created comment.
    def create_commit_comment(project, commit, note, options={})
      post("/projects/#{project}/repository/commits/#{commit}/comments", body: options.merge(note: note))
    end
    alias_method :repo_create_commit_comment, :create_commit_comment

    # Get the status of a commit
    #
    # @example
    #   Gitlab.commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #   Gitlab.commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', { name: 'jenkins' })
    #   Gitlab.commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', { name: 'jenkins', all: true })
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] sha The commit hash
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :ref Filter by ref name, it can be branch or tag
    # @option options [String] :stage Filter by stage
    # @option options [String] :name Filer by status name, eg. jenkins
    # @option options [Boolean] :all The flag to return all statuses, not only latest ones
    def commit_status(id, sha, options={})
      get("/projects/#{id}/repository/commits/#{sha}/statuses", query: options)
    end
    alias_method :repo_commit_status, :commit_status

    # Adds or updates a status of a commit.
    #
    # @example
    #   Gitlab.update_commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'success')
    #   Gitlab.update_commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'failed', { name: 'jenkins' })
    #   Gitlab.update_commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'canceled', { name: 'jenkins', target_url: 'http://example.com/builds/1' })
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] sha The commit hash
    # @param  [String] state of the status. Can be: pending, running, success, failed, canceled
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :ref The ref (branch or tag) to which the status refers
    # @option options [String] :name Filer by status name, eg. jenkins
    # @option options [String] :target_url The target URL to associate with this status
    def update_commit_status(id, sha, state, options={})
      post("/projects/#{id}/statuses/#{sha}", query: options.merge(state: state))
    end
    alias_method :repo_update_commit_status, :update_commit_status
  end
end
