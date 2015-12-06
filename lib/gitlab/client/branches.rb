class Gitlab::Client
  # Defines methods related to repositories.
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/branches.md
  module Branches
    # Gets a list of project repositiory branches.
    #
    # @example
    #   Gitlab.branches(42)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def branches(project, options={})
      get("/projects/#{project}/repository/branches", query: options)
    end
    alias_method :repo_branches, :branches

    # Gets information about a repository branch.
    #
    # @example
    #   Gitlab.branch(3, 'api')
    #   Gitlab.repo_branch(5, 'master')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] branch The name of the branch.
    # @return [Gitlab::ObjectifiedHash]
    def branch(project, branch)
      get("/projects/#{project}/repository/branches/#{branch}")
    end
    alias_method :repo_branch, :branch

    # Protects a repository branch.
    #
    # @example
    #   Gitlab.protect_branch(3, 'api')
    #   Gitlab.repo_protect_branch(5, 'master')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] branch The name of the branch.
    # @return [Gitlab::ObjectifiedHash]
    def protect_branch(project, branch)
      put("/projects/#{project}/repository/branches/#{branch}/protect")
    end
    alias_method :repo_protect_branch, :protect_branch

    # Unprotects a repository branch.
    #
    # @example
    #   Gitlab.unprotect_branch(3, 'api')
    #   Gitlab.repo_unprotect_branch(5, 'master')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] branch The name of the branch.
    # @return [Gitlab::ObjectifiedHash]
    def unprotect_branch(project, branch)
      put("/projects/#{project}/repository/branches/#{branch}/unprotect")
    end
    alias_method :repo_unprotect_branch, :unprotect_branch

    # Creates a repository branch.  Requires Gitlab >= 6.8.x
    #
    # @example
    #   Gitlab.create_branch(3, 'api')
    #   Gitlab.repo_create_branch(5, 'master')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] branch The name of the new branch.
    # @param  [String] ref Create branch from commit sha or existing branch
    # @return [Gitlab::ObjectifiedHash]
    def create_branch(project, branch, ref)
      post("/projects/#{project}/repository/branches", body: { branch_name: branch, ref: ref })
    end
    alias_method :repo_create_branch, :create_branch

    # Deletes a repository branch.  Requires Gitlab >= 6.8.x
    #
    # @example
    #   Gitlab.delete_branch(3, 'api')
    #   Gitlab.repo_delete_branch(5, 'master')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] branch The name of the branch to delete
    # @return [Gitlab::ObjectifiedHash]
    def delete_branch(project, branch)
      delete("/projects/#{project}/repository/branches/#{branch}")
    end
    alias_method :repo_delete_branch, :delete_branch
  end
end
