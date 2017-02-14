class Gitlab::Client
  # Defines methods related to pipelines.
  # @see https://docs.gitlab.com/ce/api/pipelines.html
  module Pipelines
    # Gets a list of project pipelines.
    #
    # @example
    #   Gitlab.pipelines(5)
    #   Gitlab.pipelines(5, { per_page: 10, page:  2 })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def pipelines(project, options={})
      get("/projects/#{url_encode project}/pipelines", query: options)
    end

    # Gets a single pipeline.
    #
    # @example
    #   Gitlab.pipeline(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a pipeline.
    # @return [Gitlab::ObjectifiedHash]
    def pipeline(project, id)
      get("/projects/#{url_encode project}/pipelines/#{id}")
    end

    # Create a pipeline.
    #
    # @example
    #   Gitlab.create_pipeline(5, 'master')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] ref Reference to commit.
    # @return [Gitlab::ObjectifiedHash] The pipelines changes.
    def create_pipeline(project, ref)
      post("/projects/#{url_encode project}/pipeline?ref=#{ref}")
    end

    # Cancels a pipeline.
    #
    # @example
    #   Gitlab.cancel_pipeline(5, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a pipeline.
    # @return [Gitlab::ObjectifiedHash] The pipelines changes.
    def cancel_pipeline(project, id)
      post("/projects/#{url_encode project}/pipelines/#{id}/cancel")
    end

    # Retry a pipeline.
    #
    # @example
    #   Gitlab.retry_pipeline(5, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a pipeline.
    # @return [Array<Gitlab::ObjectifiedHash>] The pipelines changes.
    def retry_pipeline(project, id)
      post("/projects/#{url_encode project}/pipelines/#{id}/retry")
    end
  end
end
