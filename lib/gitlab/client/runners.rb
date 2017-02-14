class Gitlab::Client
  # Defines methods related to runners.
  # @see https://docs.gitlab.com/ce/api/runners.html
  module Runners

    # Get a list of specific runners available to the user.
    # @see https://docs.gitlab.com/ce/api/runners.html#list-owned-runners
    #
    # @example
    #   Gitlab.runners
    #   Gitlab.runners(:active)
    #   Gitlab.runners(:paused)
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :scope The scope of specific runners to show, one of: active, paused, online; showing all runners if none provided
    # @return [Array<Gitlab::ObjectifiedHash>]
    def runners(options = {})
      get("/runners", query: options)
    end

    # Get a list of all runners in the GitLab instance (specific and shared). Access is restricted to users with admin privileges.
    # @see https://docs.gitlab.com/ce/api/runners.html#list-all-runners
    #
    # @example
    #   Gitlab.all_runners
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :scope The scope of runners to show, one of: specific, shared, active, paused, online; showing all runners if none provided
    # @return [Array<Gitlab::ObjectifiedHash>]
    def all_runners(options = {})
      get("/runners/all", query: options)
    end

    # Get details of a runner..
    # @see https://docs.gitlab.com/ce/api/runners.html#get-runners-details
    #
    # @example
    #   Gitlab.runner(42)
    #
    # @param  [Integer, String] id The ID of a runner
    # @return <Gitlab::ObjectifiedHash>
    def runner(id)
      get("/runners/#{id}")
    end

    # Update details of a runner.
    # @see https://docs.gitlab.com/ce/api/runners.html#update-runners-details
    #
    # @example
    #   Gitlab.update_runner(42, { description: 'Awesome runner' })
    #   Gitlab.update_runner(42, { active: false })
    #   Gitlab.update_runner(42, { tag_list: [ 'awesome', 'runner' ] })
    #
    # @param  [Integer, String] id The ID of a runner
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :active The state of a runner; can be set to true or false.
    # @option options [String] :tag_list The list of tags for a runner; put array of tags, that should be finally assigned to a runner
    # @return <Gitlab::ObjectifiedHash>
    def update_runner(id, options={})
      put("/runners/#{id}", query: options)
    end

    # Remove a runner.
    # @see https://docs.gitlab.com/ce/api/runners.html#remove-a-runner
    #
    # @example
    #   Gitlab.delete_runner(42)
    #
    # @param  [Integer, String] id The ID of a runner
    # @return <Gitlab::ObjectifiedHash>
    def delete_runner(id)
      delete("/runners/#{id}")
    end

    # List all runners (specific and shared) available in the project. Shared runners are listed if at least one shared runner is defined and shared runners usage is enabled in the project's settings.
    # @see https://docs.gitlab.com/ce/api/runners.html#list-projects-runners
    #
    # @example
    #   Gitlab.project_runners(42)
    #
    # @param  [Integer, String] id The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def project_runners(project_id)
      get("/projects/#{url_encode project_id}/runners")
    end

    # Enable an available specific runner in the project.
    # @see https://docs.gitlab.com/ce/api/runners.html#enable-a-runner-in-project
    #
    # @example
    #   Gitlab.project_enable_runner(2, 42)
    #
    # @param  [Integer, String] id The ID or name of a project.
    # @param  [Integer, String] id The ID of a runner.
    # @return <Gitlab::ObjectifiedHash>
    def project_enable_runner(project_id, id)
      body = { runner_id: id }
      post("/projects/#{url_encode project_id}/runners", body: body)
    end

    # Disable a specific runner from the project. It works only if the project isn't the only project associated with the specified runner.
    # @see https://docs.gitlab.com/ce/api/runners.html#disable-a-runner-from-project
    #
    # @example
    #   Gitlab.project_disable_runner(2, 42)
    #
    # @param  [Integer, String] id The ID or name of a project.
    # @param  [Integer, String] runner_id The ID of a runner.
    # @return <Gitlab::ObjectifiedHash>
    def project_disable_runner(id, runner_id)
      delete("/projects/#{url_encode id}/runners/#{runner_id}")
    end

  end
end
