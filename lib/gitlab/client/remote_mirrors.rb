# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to remote mirrors.
  # @see https://docs.gitlab.com/ee/api/remote_mirrors.html
  module RemoteMirrors
    # List a project's remote mirrors
    #
    # @example
    #   Gitlab.remote_mirrors(42)
    #   Gitlab.remote_mirrors('gitlab-org/gitlab')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def remote_mirrors(project)
      get("/projects/#{url_encode project}/remote_mirrors")
    end

    # Create a remote mirror
    #
    # @example
    #   Gitlab.create_remote_mirror(42, 'https://mirror-bot@gitlab.com/gitlab-org/gitlab.git', enabled: true)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] url The full URL of the remote repository.
    # @param  [Hash] options A customizable set of options.
    # @option options [Boolean] :enabled Determines if the mirror is enabled.
    # @option options [Boolean] :only_protected_branches Determines if only protected branches are mirrored.
    # @option options [Boolean] :keep_divergent_refs Determines if divergent refs are skipped.
    # @return [Gitlab::ObjectifiedHash]
    def create_remote_mirror(project, url, options = {})
      post("/projects/#{url_encode project}/remote_mirrors", body: options.merge(url: url))
    end

    # Update a remote mirror's attributes
    #
    # @example
    #   Gitlab.edit_remote_mirror(42, 66, only_protected_branches: true)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of the remote mirror.
    # @param  [Hash] options A customizable set of options.
    # @option options [Boolean] :enabled Determines if the mirror is enabled.
    # @option options [Boolean] :only_protected_branches Determines if only protected branches are mirrored.
    # @option options [Boolean] :keep_divergent_refs Determines if divergent refs are skipped.
    # @return [Gitlab::ObjectifiedHash]
    def edit_remote_mirror(project, id, options = {})
      put("/projects/#{url_encode project}/remote_mirrors/#{id}", body: options)
    end
  end
end
