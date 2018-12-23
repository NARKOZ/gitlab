# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to repository submodules.
  # @see https://docs.gitlab.com/ce/api/repository_submodules.html
  module RepositorySubmodules
    # Edits an existing repository submodule.
    #
    # @example
    #   Gitlab.edit_file(42, "submodule", "branch", "3ddec28ea23acc5caa5d8331a6ecb2a65fc03e88", "commit message")
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] submodule full path of submodule to update.
    # @param  [String] branch the name of the branch to commit changes to.
    # @param  [String] commit_sha commit SHA to update the submodule to.
    # @param  [String] commit_message ...commit message.
    # @return [Gitlab::ObjectifiedHash]
    def edit_submodule(project, submodule, branch, commit_sha, commit_message)
      put("/projects/#{url_encode project}/repository/submodules/#{url_encode submodule}", body: {
        branch: branch,
        commit_sha: commit_sha,
        commit_message: commit_message
      })
    end
  end
end
