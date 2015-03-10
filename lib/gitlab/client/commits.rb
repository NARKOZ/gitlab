class Gitlab::Client
  # Defines methods related to repository commits.
  # https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/commits.md
  module Commits
    # Gets a list of project repository commits.
    #
    # @example
    #   Gitlab.commits(42)
    #   Gitlab.repo_commits(5)
    #
    # @param  [Integer] project The ID of a project.
    # @option options [String] :ref_name The branch / tag name, default branch if nil.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def commits(project, options={})
      get("/projects/#{project}/repository/commits", :query => options)
    end
    alias_method :repo_commits, :commits

    # Gets information about a repository commit.
    #
    # @example
    #   Gitlab.commit(3, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #   Gitlab.repo_commit(5, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] sha The sha of the commit.
    # @return [Gitlab::ObjectifiedHash]
    def commit(project, sha)
      get("/projects/#{project}/repository/commits/#{sha}")
    end
    alias_method :repo_commit, :commit

    # Gets diff info for a repository commit.
    #
    # @example
    #   Gitlab.commit_diff(3, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #   Gitlab.repo_commit_diff(5, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] sha The sha of the commit.
    # @return [Gitlab::ObjectifiedHash]
    def commit_diff(project, sha)
      get("/projects/#{project}/repository/commits/#{sha}/diff")
    end
    alias_method :repo_commit_diff, :commit_diff

    # Get the comments of a commit.
    #
    # @example
    #   Gitlab.commit_comments(3, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #   Gitlab.repo_commit_comments(5, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] sha The sha of the commit.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Gitlab::ObjectifiedHash]
    def commit_comments(project, sha, options={})
      get("/projects/#{project}/repository/commits/#{sha}/comments", query: options)
    end
    alias_method :repo_commit_comments, :commit_comments

    # Post comment to a commit.
    #
    # @example
    #   Gitlab.create_commit_comment(3, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'comment')
    #   Gitlab.repo_create_commit_comment(5, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'comment')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] sha The sha of the commit.
    # @param  [String] comment The comment to add.
    # @option options [String] :path Teh file path.
    # @option options [Integer] :line The line number.
    # @option options [Integer] :line_type The line type (new or old).
    # @return [Gitlab::ObjectifiedHash]
    def create_commit_comment(project, sha, comment, options={})
      post("/projects/#{project}/repository/commits/#{sha}/comments", body: { note: comment }.merge(options))
    end
    alias_method :repo_create_commit_comment, :create_commit_comment

  end
end

