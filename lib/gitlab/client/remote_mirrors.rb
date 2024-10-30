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

    # Get a specific remote mirror.
    #
    # @example
    #   Gitlab.remote_mirror(42, 1234)
    #
    # @param [Integer, String] project The ID or path of a project.
    # @param [Integer] id The ID of the remote mirror.
    #
    # @return [Gitlab::ObjectifiedHash] Information about the specified remote mirror.
    def remote_mirror(project, id)
      get("/projects/#{url_encode project}/remote_mirrors/#{id}")
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

    # Delete a remote mirror.
    #
    # @example
    #   Gitlab.delete_remote_mirror(42, 1234)
    #
    # @param [Integer, String] project The ID or path of a project.
    # @param [Integer] id The ID of the remote mirror.
    #
    # @return [Gitlab::ObjectifiedHash]
    def delete_remote_mirror(project, id)
      delete("/projects/#{url_encode project}/remote_mirrors/#{id}")
    end

    # Force push mirror update.
    #
    # @example
    #   Gitlab.sync_remote_mirror(42, 1234)
    #
    # @param [Integer, String] project The ID or path of a project.
    # @param [Integer] id The ID of the remote mirror.
    #
    # @return [Gitlab::ObjectifiedHash]
    def sync_remote_mirror(project, id)
      post("/projects/#{url_encode project}/remote_mirrors/#{id}/sync")
    end
  end
end
