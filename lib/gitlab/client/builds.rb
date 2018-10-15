# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to builds.
  # @see https://docs.gitlab.com/ce/api/builds.html
  module Builds
    # Gets a list of project builds.
    #
    # @example
    #   Gitlab.builds(5)
    #   Gitlab.builds(5, { per_page: 10, page:  2 })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @param  [Integer, String] project The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def builds(project, options = {})
      get("/projects/#{url_encode project}/builds", query: options)
    end

    # Gets a single build.
    #
    # @example
    #   Gitlab.build(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a build.
    # @return [Gitlab::ObjectifiedHash]
    def build(project, id)
      get("/projects/#{url_encode project}/builds/#{id}")
    end

    # Gets build artifacts.
    #
    # @example
    #   Gitlab.build_artifacts(1, 8)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a build.
    # @return [Gitlab::FileResponse]
    def build_artifacts(project, id)
      get("/projects/#{url_encode project}/builds/#{id}/artifacts",
          format: nil,
          headers: { Accept: 'application/octet-stream' },
          parser: proc { |body, _|
                    if body.encoding == Encoding::ASCII_8BIT # binary response
                      ::Gitlab::FileResponse.new StringIO.new(body, 'rb+')
                    else # error with json response
                      ::Gitlab::Request.parse(body)
                    end
                  })
    end

    # Gets a list of builds for specific commit in a project.
    #
    # @example
    #   Gitlab.commit_builds(5, 'asdf')
    #   Gitlab.commit_builds(5, 'asdf', { per_page: 10, page: 2 })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] sha The SHA checksum of a commit.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>] The list of builds.
    def commit_builds(project, sha, options = {})
      get("/projects/#{url_encode project}/repository/commits/#{sha}/builds", query: options)
    end

    # Cancels a build.
    #
    # @example
    #   Gitlab.build_cancel(5, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a build.
    # @return [Gitlab::ObjectifiedHash] The builds changes.
    def build_cancel(project, id)
      post("/projects/#{url_encode project}/builds/#{id}/cancel")
    end

    # Retry a build.
    #
    # @example
    #   Gitlab.build_retry(5, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a build.
    # @return [Array<Gitlab::ObjectifiedHash>] The builds changes.
    def build_retry(project, id)
      post("/projects/#{url_encode project}/builds/#{id}/retry")
    end

    # Erase a single build of a project (remove build artifacts and a build trace)
    #
    # @example
    #   Gitlab.build_erase(5, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a build.
    # @return [Gitlab::ObjectifiedHash] The build's changes.
    def build_erase(project, id)
      post("/projects/#{url_encode project}/builds/#{id}/erase")
    end
  end
end
