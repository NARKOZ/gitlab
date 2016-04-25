class Gitlab::Client
  # Defines methods related to builds.
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/build_triggers.md
  module BuildTriggers
    # Gets a list of the project's build triggers
    #
    # @example
    #   Gitlab.triggers(5)
    #
    # @param  [Integer] project The ID of a project.
    # @return [Array<Gitlab::ObjectifiedHash>] The list of triggers.
    def triggers(project)
      get("/projects/#{project}/triggers")
    end

    # Gets details of project's build trigger.
    #
    # @example
    #   Gitlab.trigger(5, '7b9148c158980bbd9bcea92c17522d')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] token The token of a trigger.
    # @return [Gitlab::ObjectifiedHash] The trigger.
    def trigger(project, token)
      get("/projects/#{project}/triggers/#{token}")
    end

    # Create a build trigger for a project.
    #
    # @example
    #   Gitlab.create_trigger(5)
    #
    # @param  [Integer] project The ID of a project.
    # @return [Gitlab::ObjectifiedHash] The trigger.
    def create_trigger(project)
      post("/projects/#{project}/triggers")
    end

    # Remove a project's build trigger.
    #
    # @example
    #   Gitlab.remove_trigger(5, '7b9148c158980bbd9bcea92c17522d')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] token The token of a trigger.
    # @return [Gitlab::ObjectifiedHash] The trigger.
    def remove_trigger(project, token)
      delete("/projects/#{project}/triggers/#{token}")
    end
  end
end
