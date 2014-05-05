class Gitlab::Client
  # Defines methods related to repositories.
  module Repositories
    # Gets a list of project repository tags.
    #
    # @example
    #   Gitlab.tags(42)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def tags(project, options={})
      get("/projects/#{project}/repository/tags", :query => options)
    end
    alias_method :repo_tags, :tags

    # Gets a list of project commits.
    #
    # @example
    #   Gitlab.commits('viking')
    #   Gitlab.repo_commits('gitlab', :ref_name => 'api')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :ref_name The branch or tag name of a project repository.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def commits(project, options={})
      get("/projects/#{project}/repository/commits", :query => options)
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
  end
end
