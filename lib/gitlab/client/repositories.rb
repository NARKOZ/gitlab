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

    # Creates a new project repository tag.
    #
    # @example
    #   Gitlab.create_tag(42,'new_tag','master')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String]  tag_name The name of the new tag.
    # @param  [String]  ref The ref (commit sha, branch name, or another tag) the tag will point to.
    # @param  [String]  message Optional message for tag, creates annotated tag if specified.
    # @return [Gitlab::ObjectifiedHash]
    def create_tag(project, tag_name, ref, message='')
      post("/projects/#{project}/repository/tags", body: {tag_name: tag_name, ref: ref, message: message})
    end
    alias_method :repo_create_tag, :create_tag

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

    # Get file tree project (root level).
    #
    # @example
    #   Gitlab.tree(42)
    #   Gitlab.tree(42, path: "Gemfile")
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @return [Gitlab::ObjectifiedHash]
    def tree(project, options={})
      get("/projects/#{project}/repository/tree", query: options)
    end
    alias_method :repo_tree, :tree
  end
end
