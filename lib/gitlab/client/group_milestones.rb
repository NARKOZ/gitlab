# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to group milestones.
  # @see https://docs.gitlab.com/ee/api/group_milestones.html
  module GroupMilestones
    # Gets a list of a group's milestones.
    #
    # @example
    #   Gitlab.group_milestones(5)
    #
    # @param  [Integer, String] id The ID or name of a group.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def group_milestones(id, options = {})
      get("/groups/#{url_encode id}/milestones", query: options)
    end

    # Gets a single group milestone.
    #
    # @example
    #   Gitlab.group_milestone(5, 36)
    #
    # @param  [Integer, String] id The ID or name of a group.
    # @param  [Integer] milestone_id The ID of a milestone.
    # @return [Gitlab::ObjectifiedHash]
    def group_milestone(id, milestone_id)
      get("/groups/#{url_encode id}/milestones/#{milestone_id}")
    end

    # Creates a new group milestone.
    #
    # @example
    #   Gitlab.create_group_milestone(5, 'v1.0')
    #
    # @param  [Integer, String] id The ID or name of a group.
    # @param  [String] title The title of a milestone.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description The description of a milestone.
    # @option options [String] :due_date The due date of a milestone.
    # @return [Gitlab::ObjectifiedHash] Information about created milestone.
    def create_group_milestone(id, title, options = {})
      body = { title: title }.merge(options)
      post("/groups/#{url_encode id}/milestones", body: body)
    end

    # Updates a group milestone.
    #
    # @example
    #   Gitlab.edit_group_milestone(5, 2, { state_event: 'activate' })
    #
    # @param  [Integer, String] id The ID or name of a group.
    # @param  [Integer] milestone_id The ID of a milestone.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title The title of a milestone.
    # @option options [String] :description The description of a milestone.
    # @option options [String] :due_date The due date of a milestone.
    # @option options [String] :state_event The state of a milestone ('close' or 'activate').
    # @return [Gitlab::ObjectifiedHash] Information about updated milestone.
    def edit_group_milestone(id, milestone_id, options = {})
      put("/groups/#{url_encode id}/milestones/#{milestone_id}", body: options)
    end

    # Gets the issues of a given group milestone.
    #
    # @example
    #   Gitlab.group_milestone_issues(5, 2)
    #
    # @param  [Integer, String] id The ID or name of a group.
    # @param  [Integer, String] milestone_id The ID of a milestone.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def group_milestone_issues(id, milestone_id, options = {})
      get("/groups/#{url_encode id}/milestones/#{milestone_id}/issues", query: options)
    end

    # Gets the merge_requests of a given group milestone.
    #
    # @example
    #   Gitlab.group_milestone_merge_requests(5, 2)
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer, String] milestone_id The ID of a milestone.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def group_milestone_merge_requests(id, milestone_id, options = {})
      get("/groups/#{url_encode id}/milestones/#{milestone_id}/merge_requests", query: options)
    end
  end
end
