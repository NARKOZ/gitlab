# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to repository submodules.
  # @see https://docs.gitlab.com/ce/api/repository_submodules.html
  module RepositorySubmodules
    # Edits an existing repository submodule.
    #
    # @example
    #   Gitlab.edit_file(42, "submodule", {
    #     branch: "branch",
    #     commit_sha: "3ddec28ea23acc5caa5d8331a6ecb2a65fc03e88",
    #     commit_message: "commit message"
    #   })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] submodule full path of submodule to update.
    # @param  [Hash] options A customizable set of options.
    # @param  options [String] :branch the name of the branch to commit changes to.
    # @param  options [String] :commit_sha commit SHA to update the submodule to.
    # @param  options [String] :commit_message commit message text.
    # @return [Gitlab::ObjectifiedHash]
    def edit_submodule(project, submodule, options = {})
      put("/projects/#{url_encode project}/repository/submodules/#{url_encode submodule}", body: options)
    end
  end
end
