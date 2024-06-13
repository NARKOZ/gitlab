# frozen_string_literal: true

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
    def pipelines(project, options = {})
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

    # Gets a single pipeline's test report.
    #
    # @example
    #   Gitlab.pipeline_test_report(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a pipeline.
    # @return [Gitlab::ObjectifiedHash]
    def pipeline_test_report(project, id)
      get("/projects/#{url_encode project}/pipelines/#{id}/test_report")
    end

    # Gets a single pipeline's variables.
    #
    # @example
    #   Gitlab.pipeline_variables(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a pipeline.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def pipeline_variables(project, id)
      get("/projects/#{url_encode project}/pipelines/#{id}/variables")
    end

    # Create a pipeline.
    #
    # @example
    #   Gitlab.create_pipeline(5, 'master')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] ref Reference to commit.
    # @param  [Hash] variables Variables passed to pipelines
    # @return [Gitlab::ObjectifiedHash] The pipelines changes.
    def create_pipeline(project, ref, variables = {})
      body = {}

      # This mapping is necessary, cause the API expects an array with objects (with `key` and `value` keys)
      # See: https://docs.gitlab.com/ee/api/pipelines.html#create-a-new-pipeline
      body[:variables] = variables.map { |(key, value)| { key: key, value: value } } if variables.any?

      post(
        "/projects/#{url_encode project}/pipeline",
        query: { ref: ref },
        body: body
      )
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

    # Delete a pipeline
    #
    # @example
    #   Gitlab.delete_pipeline(5, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a pipeline.
    # @return [void] This API call returns an empty response body.
    def delete_pipeline(project, id)
      delete("/projects/#{url_encode project}/pipelines/#{id}")
    end

    # Update a pipeline metadata
    #
    # @example
    #   Gitlab.update_pipeline_metadata(5, 1, name: 'new name')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a pipeline.
    # @option options [String] :name The new name of the pipeline.
    # @return [Gitlab::ObjectifiedHash]
    def update_pipeline_metadata(project, id, options = {})
      put("/projects/#{url_encode project}/pipelines/#{id}/metadata", body: options)
    end
  end
end
