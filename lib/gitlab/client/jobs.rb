# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to projects.
  # @see https://docs.gitlab.com/ee/api/jobs.html
  module Jobs
    # Gets a list of Jobs for a Project
    #
    # @example
    #   Gitlab.jobs(1)
    #   Gitlab.jobs("project")
    #   Gitlab.jobs("project", {scope: ["manual", "success"], per_page: 100 })
    #
    # @param  [Integer, String] id The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Array] :scope The scope of jobs to show, one or array of: created, pending, running, failed, success, canceled, skipped, manual; showing all jobs if none provided.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def jobs(project_id, options = {})
      get("/projects/#{url_encode project_id}/jobs", query: options)
    end

    # Gets a list of Jobs from a pipeline
    #
    # @example
    #   Gitlab.pipeline_jobs(1, 2)
    #   Gitlab.pipeline_jobs("project", 2)
    #
    # @param  [Integer, String] The ID or name of a project.
    # @param  [Integer]  the id of the pipeline
    # @param  [Hash] options A customizable set of options.
    # @option options [Array] :scope The scope of jobs to show, one or array of: created, pending, running, failed, success, canceled, skipped, manual; showing all jobs if none provided.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def pipeline_jobs(project_id, pipeline_id, options = {})
      get("/projects/#{url_encode project_id}/pipelines/#{pipeline_id}/jobs", query: options)
    end

    # Gets a list of Bridge Jobs from a pipeline
    #
    # @example
    #   Gitlab.pipeline_bridges(1, 2)
    #   Gitlab.pipeline_bridges("project", 2)
    #
    # @param  [Integer, String] The ID or name of a project.
    # @param  [Integer]  the id of the pipeline
    # @param  [Hash] options A customizable set of options.
    # @option options [Array] :scope The scope of bridge jobs to show, one or array of: created, pending, running, failed, success, canceled, skipped, manual; showing all bridge jobs if none provided.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def pipeline_bridges(project_id, pipeline_id, options = {})
      get("/projects/#{url_encode project_id}/pipelines/#{pipeline_id}/bridges", query: options)
    end

    # Gets a single job
    #
    # @example
    #   Gitlab.job(1, 2)
    #   Gitlab.job("project", 2)
    #
    # @param  [Integer, String] The ID or name of a project.
    # @param  [Integer]  the id of the job
    def job(project_id, job_id)
      get("/projects/#{url_encode project_id}/jobs/#{job_id}")
    end

    # Gets artifacts from a job
    #
    # @example
    #   Gitlab.job_artifacts(1, 2)
    #   Gitlab.job_artifacts("project", 2)
    #
    # @param  [Integer, String] The ID or name of a project.
    # @param  [Integer]  the id of the job
    # @return [Array<Gitlab::ObjectifiedHash>]
    def job_artifacts(project_id, job_id)
      get("/projects/#{url_encode project_id}/jobs/#{job_id}/artifacts",
          format: nil,
          headers: { Accept: 'text/plain' },
          parser: ::Gitlab::Request::Parser)
    end

    # Download Job Artifact
    #
    # @example
    #   Gitlab.job_artifacts_download(1, "master", "release")
    #   Gitlab.job_artifacts_download("project", "master", "release")
    #
    # @param  [Integer, String] project_id The ID or name of a project.
    # @param  [String]  ref Ref Name
    # @param  [String]  job jobname
    # @return [Gitlab::FileResponse]
    def job_artifacts_download(project_id, ref_name, job_name)
      get("/projects/#{url_encode project_id}/jobs/artifacts/#{ref_name}/download",
          query: { job: job_name },
          format: nil,
          headers: { Accept: 'application/octet-stream' },
          parser: proc { |body, _|
                    if body.encoding == Encoding::ASCII_8BIT # binary response
                      ::Gitlab::FileResponse.new StringIO.new(body, 'rb+')
                    else # error with json response
                      ::Gitlab::Request.parse(body)
                    end
                  })
    end

    # Download a single artifact file by job ID
    #
    # @example
    #   Gitlab.download_job_artifact_file(1, 5, "some/release/file.pdf")
    #
    # @param  [Integer, String] project_id(required) The ID or name of a project.
    # @param  [String]  job_id(required) The unique job identifier.
    # @param  [String]  artifact_path(required) Path to a file inside the artifacts archive.
    # @return [Gitlab::FileResponse]
    def download_job_artifact_file(project_id, job_id, artifact_path)
      get("/projects/#{url_encode project_id}/jobs/#{job_id}/artifacts/#{artifact_path}",
          format: nil,
          headers: { Accept: 'application/octet-stream' },
          parser: proc { |body, _|
                    if body.encoding == Encoding::ASCII_8BIT # binary response
                      ::Gitlab::FileResponse.new StringIO.new(body, 'rb+')
                    else # error with json response
                      ::Gitlab::Request.parse(body)
                    end
                  })
    end

    # Download a single artifact file from specific tag or branch
    #
    # @example
    #   Gitlab.download_branch_artifact_file(1, "master", "some/release/file.pdf", 'pdf')
    #
    # @param  [Integer, String] project_id(required) The ID or name of a project.
    # @param  [String]  ref_name(required) Branch or tag name in repository. HEAD or SHA references are not supported.
    # @param  [String]  artifact_path(required) Path to a file inside the artifacts archive.
    # @param  [String]  job(required) The name of the job.
    # @return [Gitlab::FileResponse]
    def download_branch_artifact_file(project_id, ref_name, artifact_path, job)
      get("/projects/#{url_encode project_id}/jobs/artifacts/#{ref_name}/raw/#{artifact_path}",
          query: { job: job },
          format: nil,
          headers: { Accept: 'application/octet-stream' },
          parser: proc { |body, _|
                    if body.encoding == Encoding::ASCII_8BIT # binary response
                      ::Gitlab::FileResponse.new StringIO.new(body, 'rb+')
                    else # error with json response
                      ::Gitlab::Request.parse(body)
                    end
                  })
    end
    alias download_tag_artifact_file download_branch_artifact_file

    # Get Job Trace
    #
    # @example
    #   Gitlab.job_trace(1,1)
    #   Gitlab.job_trace("project", 1)
    #
    # @param  [Integer, String] The ID or name of a project.
    # @param  [Integer]  the id of the job
    # @return [Array<Gitlab::ObjectifiedHash>]
    def job_trace(project_id, job_id)
      get("/projects/#{url_encode project_id}/jobs/#{job_id}/trace",
          format: nil,
          headers: { Accept: 'text/plain' },
          parser: ::Gitlab::Request::Parser)
    end

    # Cancel a job
    #
    # @example
    #   Gitlab.job_cancel(1,1)
    #   Gitlab.job_cancel("project", 1)
    #
    # @param  [Integer, String] The ID or name of a project.
    # @param  [Integer]  the id of the job
    # @return [Array<Gitlab::ObjectifiedHash>]
    def job_cancel(project_id, job_id)
      post("/projects/#{url_encode project_id}/jobs/#{job_id}/cancel")
    end

    # Retry a job
    #
    # @example
    #   Gitlab.job_retry(1,1)
    #   Gitlab.job_retry("project", 1)
    #
    # @param  [Integer, String] The ID or name of a project.
    # @param  [Integer]  the id of the job
    # @return [Array<Gitlab::ObjectifiedHash>]
    def job_retry(project_id, job_id)
      post("/projects/#{url_encode project_id}/jobs/#{job_id}/retry")
    end

    # Erase Job
    #
    # @example
    #   Gitlab.job_erase(1,1)
    #   Gitlab.job_erase("project", 1)
    #
    # @param  [Integer, String] The ID or name of a project.
    # @param  [Integer]  the id of the job
    # @return [Array<Gitlab::ObjectifiedHash>]
    def job_erase(project_id, job_id)
      post("/projects/#{url_encode project_id}/jobs/#{job_id}/erase")
    end

    # Play a Job
    # Triggers a manual action to start a job.
    #
    # @example
    #   Gitlab.job_play(1,1)
    #   Gitlab.job_play("project", 1)
    #
    # @param  [Integer, String] The ID or name of a project.
    # @param  [Integer]  the id of the job
    # @return [Array<Gitlab::ObjectifiedHash>]
    def job_play(project_id, job_id)
      post("/projects/#{url_encode project_id}/jobs/#{job_id}/play")
    end

    # Keep Artifacts
    # Prevents artifacts from being deleted when expiration is set.
    #
    # @example
    #   Gitlab.job_artifacts_keep(1,1)
    #   Gitlab.job_artifacts_keep("project", 1)
    #
    # @param  [Integer, String] The ID or name of a project.
    # @param  [Integer]  the id of the job
    # @return [Array<Gitlab::ObjectifiedHash>]
    def job_artifacts_keep(project_id, job_id)
      post("/projects/#{url_encode project_id}/jobs/#{job_id}/artifacts/keep")
    end

    # Delete Artifacts
    # Deletes the artifacts associated with a job.
    #
    # @example
    #   Gitlab.job_artifacts_delete(1,1)
    #   Gitlab.job_artifacts_delete("project", 1)
    #
    # @param  [Integer, String] The ID or name of a project.
    # @param  [Integer]  the id of the job
    # @return [Array<Gitlab::ObjectifiedHash>]
    def job_artifacts_delete(project_id, job_id)
      delete("/projects/#{url_encode project_id}/jobs/#{job_id}/artifacts")
    end
  end
end
