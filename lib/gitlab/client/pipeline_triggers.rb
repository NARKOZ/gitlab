class Gitlab::Client
  # Defines methods related to pipelines.
  # @see https://docs.gitlab.com/ce/api/pipeline_triggers.html
  module PipelineTriggers
    # Gets a list of the project's pipeline triggers
    #
    # @example
    #   Gitlab.triggers(5)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>] The list of triggers.
    def triggers(project)
      get("/projects/#{url_encode project}/triggers")
    end

    # Gets details of project's pipeline trigger.
    #
    # @example
    #   Gitlab.trigger(5, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] trigger_id The trigger ID.
    # @return [Gitlab::ObjectifiedHash] The trigger.
    def trigger(project, trigger_id)
      get("/projects/#{url_encode project}/triggers/#{trigger_id}")
    end

    # Create a pipeline trigger for a project.
    #
    # @example
    #   Gitlab.create_trigger(5, description: "my description")
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] description The trigger name
    # @return [Gitlab::ObjectifiedHash] The created trigger.
    def create_trigger(project, description)
      post("/projects/#{url_encode project}/triggers", body: {description: description})
    end

    # Update a project trigger
    #
    # @example
    #   Gitlab.update_trigger(5, 1, description: "my description")
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] trigger_id The trigger ID.
    # @param [Hash] options A customizable set of options.
    # @option options [String] :description The trigger name.
    # @return [Gitlab::ObjectifiedHash] The updated trigger.
    def update_trigger(project, trigger_id, options={})
      put("/projects/#{url_encode project}/triggers/#{trigger_id}", body: options)
    end

    # Take ownership of a project trigger
    #
    # @example
    #   Gitlab.trigger_take_ownership(5, 1)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] trigger_id The trigger ID.
    # @return [Gitlab::ObjectifiedHash] The updated trigger.
    def trigger_take_ownership(project, trigger_id)
      post("/projects/#{url_encode project}/triggers/#{trigger_id}/take_ownership")
    end

    # Remove a project's pipeline trigger.
    #
    # @example
    #   Gitlab.remove_trigger(5, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] trigger_id The trigger ID.
    # @return [void]    This API call returns an empty response body.
    def remove_trigger(project, trigger_id)
      delete("/projects/#{url_encode project}/triggers/#{trigger_id}")
    end
    alias_method :delete_trigger, :remove_trigger
  end
end
