# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to repositories.
  # @see https://docs.gitlab.com/ce/api/branches.html
  module Branches
    # Gets a list of project repositiory branches.
    #
    # @example
    #   Gitlab.branches(42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def branches(project, options = {})
      get("/projects/#{url_encode project}/repository/branches", query: options)
    end
    alias repo_branches branches

    # Gets information about a repository branch.
    #
    # @example
    #   Gitlab.branch(3, 'api')
    #   Gitlab.repo_branch(5, 'master')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] branch The name of the branch.
    # @return [Gitlab::ObjectifiedHash]
    def branch(project, branch)
      get("/projects/#{url_encode project}/repository/branches/#{url_encode branch}")
    end
    alias repo_branch branch

    # Protects a repository branch.
    #
    # @example
    #   Gitlab.protect_branch(3, 'api')
    #   Gitlab.repo_protect_branch(5, 'master')
    #   Gitlab.protect_branch(5, 'api', push_access_level: 30)
    #
    # To update options, use update_protected_branch
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] branch The name of the branch.
    # @param  [Hash] options A customizable set of options.
    #   See https://docs.gitlab.com/api/protected_branches/#protect-repository-branches for details.
    # @return [Gitlab::ObjectifiedHash] Details about the branch
    def protect_branch(project, branch, options = {})
      post("/projects/#{url_encode project}/protected_branches",
           headers: { 'Content-Type' => 'application/json' }, body: { name: branch }.merge(options).to_json)
    end
    alias repo_protect_branch protect_branch

    # Updates a protected repository branch.
    #
    # @example
    #   Gitlab.update_protected_branch(5, 'api', { allowed_to_push: [{ access_level => 40 }, { user_id => 5 }] })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] branch The name of the branch.
    # @param  [Hash] options A customizable set of options.
    #   See https://docs.gitlab.com/api/protected_branches/#update-a-protected-branches for details.
    # @return [Gitlab::ObjectifiedHash] Details about the branch
    def update_protected_branch(project, branch, options = {})
      patch("/projects/#{url_encode project}/protected_branches/#{url_encode branch}",
            headers: { 'Content-Type' => 'application/json' }, body: options.to_json)
    end
    alias repo_update_protected_branch update_protected_branch

    # Unprotects a repository branch.
    #
    # @example
    #   Gitlab.unprotect_branch(3, 'api')
    #   Gitlab.repo_unprotect_branch(5, 'master')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] branch The name of the branch.
    # @return [Gitlab::ObjectifiedHash] Details about the branch
    def unprotect_branch(project, branch)
      delete("/projects/#{url_encode project}/protected_branches/#{url_encode branch}")
    end
    alias repo_unprotect_branch unprotect_branch

    # Creates a repository branch.  Requires Gitlab >= 6.8.x
    #
    # @example
    #   Gitlab.create_branch(3, 'api', 'feat/new-api')
    #   Gitlab.repo_create_branch(5, 'master', 'develop')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] branch The name of the new branch.
    # @param  [String] ref Create branch from commit sha or existing branch
    # @return [Gitlab::ObjectifiedHash] Details about the branch
    def create_branch(project, branch, ref)
      post("/projects/#{url_encode project}/repository/branches", query: { branch: branch, ref: ref })
    end
    alias repo_create_branch create_branch

    # Deletes a repository branch.  Requires Gitlab >= 6.8.x
    #
    # @example
    #   Gitlab.delete_branch(3, 'api')
    #   Gitlab.repo_delete_branch(5, 'master')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] branch The name of the branch to delete
    def delete_branch(project, branch)
      delete("/projects/#{url_encode project}/repository/branches/#{url_encode branch}")
    end
    alias repo_delete_branch delete_branch

    # Delete all branches that are merged into the project default branch. Protected branches will not be deleted as part of this operation.
    #
    # @example
    #   Gitlab.delete_merged_branches(3)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @return [nil] This API call returns an empty response body.
    def delete_merged_branches(project)
      delete("/projects/#{url_encode project}/repository/merged_branches")
    end
    alias repo_delete_merged_branches delete_merged_branches

    # Gets a list of protected branches from a project.
    #
    # @example
    #   Gitlab.protected_branches(42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def protected_branches(project)
      get("/projects/#{url_encode project}/protected_branches")
    end
    alias repo_protected_branches protected_branches

    # Gets a single protected branch or wildcard protected branch
    #
    # @example
    #   Gitlab.protected_branch(3, 'api')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] name The name of the branch or wildcard
    # @return [Gitlab::ObjectifiedHash]
    def protected_branch(project, branch)
      get("/projects/#{url_encode project}/protected_branches/#{url_encode branch}")
    end
    alias repo_protected_branch protected_branch
  end
end
