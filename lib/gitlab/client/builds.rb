class Gitlab::Client
  # Defines methods related to builds.
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/builds.md
  module Builds
    # Gets a list of project builds.
    #
    # @example
    #   Gitlab.builds(5)
    #   Gitlab.builds(5, { per_page: 10, page:  2 })
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @param  [Integer] project The ID of a project.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def builds(project, options={})
      get("/projects/#{project}/builds", query: options)
    end

    # Gets a single build.
    #
    # @example
    #   Gitlab.build(5, 36)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] id The ID of a build.
    # @return <Gitlab::ObjectifiedHash]
    def build(project, id)
      get("/projects/#{project}/build/#{id}")
    end

    # Gets a list of builds for specific commit in a project.
    #
    # @example
    #   Gitlab.commit_builds(5, 'asdf')
    #   Gitlab.commit_builds(5, 'asdf', { per_page: 10, page: 2 })
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] sha The SHA checksum of a commit.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>] The list of builds.
    def commit_builds(project, sha, options={})
      get("/projects/#{project}/repository/commits/#{sha}/builds", query: options)
    end

    # Cancels a build.
    #
    # @example
    #   Gitlab.build_cancel(5, 1)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] id The ID of a build.
    # @return [Gitlab::ObjectifiedHash] The builds changes.
    def build_cancel(project, id)
      post("/projects/#{project}/builds/#{id}/cancel")
    end

    # Retry a build.
    #
    # @example
    #   Gitlab.build_retry(5, 1)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] id The ID of a build.
    # @return [Array<Gitlab::ObjectifiedHash>] The builds changes.
    def build_retry(project, id)
      post("/projects/#{project}/builds/#{id}/retry")
    end
  end
end
