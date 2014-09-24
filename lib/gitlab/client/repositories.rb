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
    # @return [Gitlab::ObjectifiedHash]
    def create_tag(project, tag_name, ref)
      post("/projects/#{project}/repository/tags", body: {tag_name: tag_name, ref: ref})
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

    # Compare branches, tags or commits
    #
    # @example
    #   Gitlab.compare(42, 'master', 'feature/branch')
    #   Gitlab.repo_compare(42, 'master', 'feature/branch')
    #
    # @param [Integer] project The ID of a project.
    # @param [String] the commit SHA or branch name of from branch
    # @param [String] the commit SHA or branch name of to branch
    # @retuen [Gitlab::ObjectifiedHash]
    def compare(project, from, to)
      get("/projects/#{project}/repository/compare?from=#{from}&to=#{to}")
    end
    alias_method :repo_compare, :compare

    # Raw file content
    #
    # @example
    #   Gitlab.contents(42, "ed899a2f4b50b4370feeea94676502b42383c746", "path/of/file")
    #   Gitlab.repo_contents(42, "ed899a2f4b50b4370feeea94676502b42383c746", "path/of/file")
    #
    # @param [Integer] project The ID of a project.
    # @param [String]  The commit or branch name
    # @param [String] The path the file
    # @return [Gitlab::ObjectifiedHash]
    def contents(project, sha, file_path)
      raw_get("/projects/#{project}/repository/blobs/#{sha}?filepath=#{file_path}")
    end
    alias_method :repo_contents, :contents

    # Get the comments of a commit in a project.
    def commit_comments project, sha
      get("/projects/#{project}/repository/commits/#{sha}/comments")
    end
    alias_method :repo_commit_comments, :commit_comments

    # Adds a comment to a commit.
    #
    def create_commit_comments project, sha, note, options = {}
      post("/projects/#{project}/repository/commits/#{sha}/comments", body: {
        note: note,
        path: options[:path],
        line: options[:line],
        line_type: options[:line_type]
      })
    end

  end
end
