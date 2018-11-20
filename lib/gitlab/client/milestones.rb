# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to milestones.
  # @see https://docs.gitlab.com/ce/api/milestones.html
  module Milestones
    # Gets a list of project's milestones.
    #
    # @example
    #   Gitlab.milestones(5)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def milestones(project, options = {})
      get("/projects/#{url_encode project}/milestones", query: options)
    end

    # Gets a single milestone.
    #
    # @example
    #   Gitlab.milestone(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a milestone.
    # @return [Gitlab::ObjectifiedHash]
    def milestone(project, id)
      get("/projects/#{url_encode project}/milestones/#{id}")
    end

    # Gets the issues of a given milestone.
    #
    # @example
    #   Gitlab.milestone_issues(5, 2)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer, String] milestone The ID of a milestone.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def milestone_issues(project, milestone, options = {})
      get("/projects/#{url_encode project}/milestones/#{milestone}/issues", query: options)
    end

    # Gets the merge_requests of a given milestone.
    #
    # @example
    #   Gitlab.milestone_merge_requests(5, 2)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer, String] milestone The ID of a milestone.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def milestone_merge_requests(project, milestone, options = {})
      get("/projects/#{url_encode project}/milestones/#{milestone}/merge_requests", query: options)
    end

    # Creates a new milestone.
    #
    # @example
    #   Gitlab.create_milestone(5, 'v1.0')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] title The title of a milestone.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description The description of a milestone.
    # @option options [String] :due_date The due date of a milestone.
    # @return [Gitlab::ObjectifiedHash] Information about created milestone.
    def create_milestone(project, title, options = {})
      body = { title: title }.merge(options)
      post("/projects/#{url_encode project}/milestones", body: body)
    end

    # Updates a milestone.
    #
    # @example
    #   Gitlab.edit_milestone(5, 2, { state_event: 'activate' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a milestone.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title The title of a milestone.
    # @option options [String] :description The description of a milestone.
    # @option options [String] :due_date The due date of a milestone.
    # @option options [String] :state_event The state of a milestone ('close' or 'activate').
    # @return [Gitlab::ObjectifiedHash] Information about updated milestone.
    def edit_milestone(project, id, options = {})
      put("/projects/#{url_encode project}/milestones/#{id}", body: options)
    end

    # Delete a project milestone.
    #
    # @example
    #   Gitlab.delete_milestone(5, 2)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a milestone.
    # @return [nil] This API call returns an empty response body.
    def delete_milestone(project, id)
      delete("/projects/#{url_encode project}/milestones/#{id}")
    end
  end
end
