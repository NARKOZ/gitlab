# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to merge trains.
  # @see https://docs.gitlab.com/ee/api/merge_trains.html
  module MergeTrains
    # Get list of merge trains for a project.
    #
    # @example
    #  Gitlab.merge_trains(1, scope: :active, sort: :asc)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Hash] options A customizable set of options.
    # @option options [String] :scope The scope of merge trains to return, one of: :active, :complete
    # @option options [String] :sort Sort by created_at either 'asc' or 'desc'
    # @return [Array<Gitlab::ObjectifiedHash>]
    def merge_trains(project, options = {})
      get("/projects/#{url_encode project}/merge_trains", query: options)
    end

    # Get all merge requests added to a merge train for the requested target branch.
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [String] target_branch The target branch of the merge train.
    # @param [Hash] options A customizable set of options.
    # @option options [String] :scope The scope of merge trains to return, one of: :active, :complete
    # @option options [String] :sort Sort by created_at either 'asc' or 'desc'
    # @return [Array<Gitlab::ObjectifiedHash>]
    def merge_train_merge_requests(project, target_branch, options = {})
      get("/projects/#{url_encode project}/merge_trains/#{target_branch}", query: options)
    end

    # Get merge train information for the requested merge request.
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] merge_request_iid The IID of the merge request.
    # @return [Gitlab::ObjectifiedHash]
    def merge_train_status(project, merge_request_iid)
      get("/projects/#{url_encode project}/merge_trains/merge_requests/#{merge_request_iid}")
    end

    # Add a merge request to the merge train targeting the merge request’s target branch.
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] merge_request_iid The IID of the merge request.
    # @param [Hash] options A customizable set of options.
    # @option options [Boolean] :when_pipeline_succeeds Add merge request to merge train when pipeline succeeds.
    # @option options [String] :sha If present, the SHA must match the HEAD of the source branch, otherwise the merge fails.
    # @option options [Boolean] :squash If true, the commits are squashed into a single commit on merge.
    # @return [Array<Gitlab::ObjectifiedHash>] <description>
    def add_merge_request_to_merge_train(project, merge_request_iid, options = {})
      post("/projects/#{url_encode project}/merge_trains/merge_requests/#{merge_request_iid}", query: options)
    end
  end
end
