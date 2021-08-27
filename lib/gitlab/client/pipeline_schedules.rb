# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to pipeline schedules.
  # @see https://docs.gitlab.com/ce/api/pipeline_schedules.html
  module PipelineSchedules
    # Gets a list of project pipeline schedules.
    #
    # @example
    #   Gitlab.pipeline_schedules(5)
    #   Gitlab.pipeline_schedules(5, { scope: 'active' })
    #
    # @param   [Integer, String] project the ID or name of a project.
    # @param   [Hash] options A customizable set of options.
    # @options options [String] :scope The scope of pipeline schedules, one of a 'active' or 'inactive'.
    # @return  [Array<Gitlab::ObjectifiedHash>]
    def pipeline_schedules(project, options = {})
      get("/projects/#{url_encode project}/pipeline_schedules", query: options)
    end

    # Gets a single pipeline schedule.
    #
    # @example
    #   Gitlab.pipeline_schedule(5, 3)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of the pipeline schedule.
    # @return [Gitlab::ObjectifiedHash]
    def pipeline_schedule(project, id)
      get("/projects/#{url_encode project}/pipeline_schedules/#{id}")
    end

    # Create a pipeline schedule.
    #
    # @example
    #   Gitlab.create_pipeline_schedule(5, { description: 'example' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description The description of pipeline scehdule.
    # @option options [String] :ref The branch/tag name will be triggered.
    # @option options [String] :cron The cron (e.g. 0 1 * * *).
    # @option options [String] :cron_timezone The timezone supproted by ActiveSupport::TimeZone (e.g. Pacific Time (US & Canada)) (default: 'UTC').
    # @option options [Boolean] :active The activation of pipeline schedule. If false is set, the pipeline schedule will deactivated initially (default: true).
    # @return [Array<Gitlab::ObjectifiedHash>]
    def create_pipeline_schedule(project, options = {})
      post("/projects/#{url_encode project}/pipeline_schedules", body: options)
    end

    # Updates the pipeline schedule of a project.
    #
    # @example
    #   Gitlab.edit_pipeline_schedule(3, 2, { description: 'example2' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] The pipeline schedule ID.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description The description of pipeline scehdule.
    # @option options [String] :ref The branch/tag name will be triggered.
    # @option options [String] :cron The cron (e.g. 0 1 * * *).
    # @option options [String] :cron_timezone The timezone supproted by ActiveSupport::TimeZone (e.g. Pacific Time (US & Canada)) (default: 'UTC').
    # @option options [Boolean] :active The activation of pipeline schedule. If false is set, the pipeline schedule will deactivated initially (default: true).
    # @return [Array<Gitlab::ObjectifiedHash>] The updated pipeline schedule.
    def edit_pipeline_schedule(project, pipeline_schedule_id, options = {})
      put("/projects/#{url_encode project}/pipeline_schedules/#{pipeline_schedule_id}", body: options)
    end

    # Take ownership of a pipeline schedule.
    #
    # @example
    #   Gitlab.pipeline_schedule_take_ownership(5, 1)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] trigger_id The pipeline schedule ID.
    # @return [Gitlab::ObjectifiedHash] The updated pipeline schedule.
    def pipeline_schedule_take_ownership(project, pipeline_schedule_id)
      post("/projects/#{url_encode project}/pipeline_schedules/#{pipeline_schedule_id}/take_ownership")
    end

    # Run a scheduled pipeline immediately.
    #
    # @example
    #   Gitlab.run_pipeline_schedule(5, 1)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] trigger_id The pipeline schedule ID.
    # @return [Gitlab::ObjectifiedHash] Pipeline created message.
    def run_pipeline_schedule(project, pipeline_schedule_id)
      post("/projects/#{url_encode project}/pipeline_schedules/#{pipeline_schedule_id}/play")
    end

    # Delete a pipeline schedule.
    #
    # @example
    #   Gitlab.delete_pipeline_schedule(5, 1)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] trigger_id The pipeline schedule ID.
    # @return [Gitlab::ObjectifiedHash] The deleted pipeline schedule.
    def delete_pipeline_schedule(project, pipeline_schedule_id)
      delete("/projects/#{url_encode project}/pipeline_schedules/#{pipeline_schedule_id}")
    end

    # Create a pipeline schedule variable.
    #
    # @example
    #   Gitlab.create_pipeline_schedule_variable(5, 1, { key: 'foo', value: 'bar' })
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] trigger_id The pipeline schedule ID.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :key The key of a variable; must have no more than 255 characters; only A-Z, a-z, 0-9, and _ are allowed.
    # @option options [String] :value The value of a variable
    # @return [Array<Gitlab::ObjectifiedHash>] The created pipeline schedule variable.
    def create_pipeline_schedule_variable(project, pipeline_schedule_id, options = {})
      post("/projects/#{url_encode project}/pipeline_schedules/#{pipeline_schedule_id}/variables", body: options)
    end

    # Updates the variable of a pipeline schedule.
    #
    # @example
    #   Gitlab.edit_pipeline_schedule_variable(3, 2, "foo" { value: 'bar' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] The pipeline schedule ID.
    # @param  [String] The key of a variable.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :value The value of a variable.
    # @return [Array<Gitlab::ObjectifiedHash>] The updated pipeline schedule variable.
    def edit_pipeline_schedule_variable(project, pipeline_schedule_id, key, options = {})
      put("/projects/#{url_encode project}/pipeline_schedules/#{pipeline_schedule_id}/variables/#{url_encode key}", body: options)
    end

    # Delete the variable of a pipeline schedule
    #
    # @example
    #   Gitlab.delete_pipeline_schedule_variable(3, 2, "foo")
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] The pipeline schedule ID.
    # @param  [String] The key of a variable.
    # @return [Array<Gitlab::ObjectifiedHash>] The deleted pipeline schedule variable.
    def delete_pipeline_schedule_variable(project, pipeline_schedule_id, key, _options = {})
      delete("/projects/#{url_encode project}/pipeline_schedules/#{pipeline_schedule_id}/variables/#{url_encode key}")
    end
  end
end
