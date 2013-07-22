class Gitlab::Client
  # Defines methods related to repositories.
  module Repositories
    # Gets a list of project repository tags.
    #
    # @example
    #   Gitlab.tags(42)
    #   Gitlab.repo_tags('gitlab')
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def tags(project, options={})
      get("/projects/#{project}/repository/tags", :query => options)
    end
    alias_method :repo_tags, :tags

    # Creates a project tag.
    #
    # @example
    #   Gitlab.create_tag(42, 'v1.0', 'HEAD')
    #   Gitlab.repo_create_tag('gitlab', 'v.1.0', 'ab73d2ks9dhdk2ld9')
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [String] tag name
    # @param  [String] Git reference (Branch, Commit, Tag, etc)
    # @return [Array<Gitlab::ObjectifiedHash>]
    def create_tag(project, tag, ref)
      post("/projects/#{project}/repository/tags/#{tag}/#{ref}")
    end
    alias_method :repo_create_tag, :create_tag

    # Deletes a project tag.
    #
    # @example
    #   Gitlab.delete_tag(42, 'v1.0')
    #   Gitlab.repo_delete_tag('gitlab', 'v.1.0')
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [String] tag name
    # @return [Array<Gitlab::ObjectifiedHash>]
    def delete_tag(project, tag)
      delete("/projects/#{project}/repository/tags/#{tag}")
    end
    alias_method :repo_delete_tag, :delete_tag

    # Gets a list of project repositiory branches.

    # Gets a list of project repositiory branches.
    #
    # @example
    #   Gitlab.branches(42)
    #   Gitlab.repo_branches('gitlab')
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def branches(project, options={})
      get("/projects/#{project}/repository/branches", :query => options)
    end
    alias_method :repo_branches, :branches

    # Gets information about a repository branch.
    #
    # @example
    #   Gitlab.branch(3, 'api')
    #   Gitlab.repo_branch(5, 'master')
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [String] branch The name of the branch.
    # @return [Gitlab::ObjectifiedHash]
    def branch(project, branch)
      get("/projects/#{project}/repository/branches/#{branch}")
    end
    alias_method :repo_branch, :branch

    # Creates a branch
    #
    # @example
    #   Gitlab.create_branch(3, 'api')
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [String] branch The name of the branch.
    # @param  [String] Git reference (Branch, Commit, Tag, etc)
    # @return [Gitlab::ObjectifiedHash]
    def create_branch(project, branch, ref)
      post("/projects/#{project}/repository/branches/#{branch}/#{ref}")
    end
    alias_method :repo_create_branch, :create_branch

    # Deletes a branch
    #
    # @example
    #   Gitlab.delete_branch(3, 'api')
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [String] branch The name of the branch.
    # @return [Gitlab::ObjectifiedHash]
    def delete_branch(project, branch)
      delete("/projects/#{project}/repository/branches/#{branch}")
    end
    alias_method :repo_delete_branch, :delete_branch

    # Gets a list of project commits.
    #
    # @example
    #   Gitlab.commits('viking')
    #   Gitlab.repo_commits('gitlab', :ref_name => 'api')
    #
    # @param  [String] project The name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :ref_name The branch or tag name of a project repository.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def commits(project, options={})
      get("/projects/#{project}/repository/commits", :query => options)
    end
    alias_method :repo_commits, :commits
  end
end
