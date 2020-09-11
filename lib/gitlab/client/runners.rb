# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to runners.
  # @see https://docs.gitlab.com/ce/api/runners.html
  module Runners
    # Get a list of specific runners available to the user.
    # @see https://docs.gitlab.com/ce/api/runners.html#list-owned-runners
    #
    # @example
    #   Gitlab.runners
    #   Gitlab.runners(type: 'instance_type', status: 'active')
    #   Gitlab.runners(tag_list: 'tag1,tag2')
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :type(optional) The type of runners to show, one of: instance_type, group_type, project_type
    # @option options [String] :status(optional) The status of runners to show, one of: active, paused, online, offline
    # @option options [String] :tag_list(optional) List of the runners tags (separated by comma)
    # @return [Array<Gitlab::ObjectifiedHash>]
    def runners(options = {})
      get('/runners', query: options)
    end

    # Get a list of all runners in the GitLab instance (specific and shared). Access is restricted to users with admin privileges.
    # @see https://docs.gitlab.com/ce/api/runners.html#list-all-runners
    #
    # @example
    #   Gitlab.all_runners
    #   Gitlab.all_runners(type: 'instance_type', status: 'active')
    #   Gitlab.all_runners(tag_list: 'tag1,tag2')
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :type(optional) The type of runners to show, one of: instance_type, group_type, project_type
    # @option options [String] :status(optional) The status of runners to show, one of: active, paused, online, offline
    # @option options [String] :tag_list(optional) List of the runners tags (separated by comma)
    # @return [Array<Gitlab::ObjectifiedHash>]
    def all_runners(options = {})
      get('/runners/all', query: options)
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
    #
    # @param  [Integer, String] id The ID of a runner
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description(optional) The description of a runner
    # @option options [Boolean] :active(optional) The state of a runner; can be set to true or false
    # @option options [String] :tag_list(optional) The list of tags for a runner; put array of tags, that should be finally assigned to a runner(separated by comma)
    # @option options [Boolean] :run_untagged(optional) Flag indicating the runner can execute untagged jobs
    # @option options [Boolean] :locked(optional) Flag indicating the runner is locked
    # @option options [String] :access_level(optional) The access_level of the runner; not_protected or ref_protected
    # @option options [Integer] :maximum_timeout(optional) Maximum timeout set when this runner will handle the job
    # @return <Gitlab::ObjectifiedHash>
    def update_runner(id, options = {})
      put("/runners/#{id}", body: options)
    end

    # Remove a runner.
    # @see https://docs.gitlab.com/ce/api/runners.html#remove-a-runner
    #
    # @example
    #   Gitlab.delete_runner(42)
    #
    # @param  [Integer, String] id The ID of a runner
    # @return [nil] This API call returns an empty response body.
    def delete_runner(id)
      delete("/runners/#{id}")
    end

    # List jobs that are being processed or were processed by specified runner.
    #
    # @example
    #   Gitlab.runner_jobs(1)
    #   Gitlab.runner_jobs(1, status: 'success')
    #   Gitlab.runner_jobs(1, sort: 'desc')
    #
    # @param  [Integer] id The ID of a runner.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :status(optional) Status of the job; one of: running, success, failed, canceled
    # @option options [String] :order_by(optional) Order jobs by id.
    # @option options [String] :sort(optional) Sort jobs in asc or desc order (default: desc)
    # @return [Array<Gitlab::ObjectifiedHash>]
    def runner_jobs(runner_id, options = {})
      get("/runners/#{url_encode runner_id}/jobs", query: options)
    end

    # List all runners (specific and shared) available in the project. Shared runners are listed if at least one shared runner is defined and shared runners usage is enabled in the project's settings.
    # @see https://docs.gitlab.com/ce/api/runners.html#list-projects-runners
    #
    # @example
    #   Gitlab.project_runners(42)
    #   Gitlab.project_runners(42, type: 'instance_type', status: 'active')
    #   Gitlab.project_runners(42, tag_list: 'tag1,tag2')
    #
    # @param  [Integer, String] id The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :type(optional) The type of runners to show, one of: instance_type, group_type, project_type
    # @option options [String] :status(optional) The status of runners to show, one of: active, paused, online, offline
    # @option options [String] :tag_list(optional) List of the runners tags (separated by comma)
    # @return [Array<Gitlab::ObjectifiedHash>]
    def project_runners(project_id, options = {})
      get("/projects/#{url_encode project_id}/runners", query: options)
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

    # List all runners (specific and shared) available in the group as well its ancestor groups. Shared runners are listed if at least one shared runner is defined.
    # @see https://docs.gitlab.com/ee/api/runners.html#list-groups-runners
    #
    # @example
    #   Gitlab.group_runners(9)
    #   Gitlab.group_runners(9, type: 'instance_type', status: 'active')
    #   Gitlab.group_runners(9, tag_list: 'tag1,tag2')
    #
    # @param  [Integer, String] id The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :type(optional) The type of runners to show, one of: instance_type, group_type, project_type
    # @option options [String] :status(optional) The status of runners to show, one of: active, paused, online, offline
    # @option options [String] :tag_list(optional) List of the runners tags (separated by comma)
    # @return [Array<Gitlab::ObjectifiedHash>]
    def group_runners(group, options = {})
      get("/groups/#{url_encode group}/runners", query: options)
    end

    # Register a new Runner for the instance.
    #
    # @example
    #   Gitlab.register_runner('9142c16ea169eaaea3d752313a434a6e')
    #   Gitlab.register_runner('9142c16ea169eaaea3d752313a434a6e', description: 'Some Description', active: true, locked: false)
    #
    # @param  [String] token(required) Registration token.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description(optional) Runner description.
    # @option options [Hash] :info(optional) Runner metadata.
    # @option options [Boolean] :active(optional) Whether the Runner is active.
    # @option options [Boolean] :locked(optional) Whether the Runner should be locked for current project.
    # @option options [Boolean] :run_untagged(optional) Whether the Runner should handle untagged jobs.
    # @option options [Array<String>] :tag_list(optional) List of Runner tags.
    # @option options [Integer] :maximum_timeout(optional) Maximum timeout set when this Runner will handle the job.
    # @return <Gitlab::ObjectifiedHash> Response against runner registration
    def register_runner(token, options = {})
      body = { token: token }.merge(options)
      post('/runners', body: body)
    end

    # Deletes a registed Runner.
    #
    # @example
    #   Gitlab.delete_registered_runner('9142c16ea169eaaea3d752313a434a6e')
    #
    # @param  [String] token Runner authentication token.
    # @return [nil] This API call returns an empty response body.
    def delete_registered_runner(token)
      body = { token: token }
      delete('/runners', body: body)
    end

    # Validates authentication credentials for a registered Runner.
    #
    # @example
    #   Gitlab.verify_auth_registered_runner('9142c16ea169eaaea3d752313a434a6e')
    #
    # @param  [String] token Runner authentication token.
    # @return [nil] This API call returns an empty response body.
    def verify_auth_registered_runner(token)
      body = { token: token }
      post('/runners/verify', body: body)
    end
  end
end
