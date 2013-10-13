class Gitlab::Client
  # Defines methods related to milestones.
  module Milestones
    # Gets a list of project's milestones.
    #
    # @example
    #   Gitlab.milestones(5)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def milestones(project, options={})
      get("/projects/#{project}/milestones", :query => options)
    end

    # Gets a single milestone.
    #
    # @example
    #   Gitlab.milestone(5, 36)
    #
    # @param  [Integer, String] project The ID of a project.
    # @param  [Integer] id The ID of a milestone.
    # @return [Gitlab::ObjectifiedHash]
    def milestone(project, id)
      get("/projects/#{project}/milestones/#{id}")
    end

    # Creates a new milestone.
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] title The title of a milestone.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description The description of a milestone.
    # @option options [String] :due_date The due date of a milestone.
    # @return [Gitlab::ObjectifiedHash] Information about created milestone.
    def create_milestone(project, title, options={})
      body = {:title => title}.merge(options)
      post("/projects/#{project}/milestones", :body => body)
    end

    # Updates a milestone.
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] id The ID of a milestone.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title The title of a milestone.
    # @option options [String] :description The description of a milestone.
    # @option options [String] :due_date The due date of a milestone.
    # @option options [String] :state_event The state of a milestone ('close' or 'activate').
    # @return [Gitlab::ObjectifiedHash] Information about updated milestone.
    def edit_milestone(project, id, options={})
      put("/projects/#{project}/milestones/#{id}", :body => options)
    end
  end
end
