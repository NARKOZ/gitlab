# frozen_string_literal: true

class Gitlab::Client
  # implements methods for project import/export
  # @see https://docs.gitlab.com/ee/api/project_import_export.html
  module ProjectImportExport
    # Schedules an export job for a project
    #
    #  @example
    #     Gitlab.project_export(1)
    #     Gitlab.project_export(1, description: "Tribute")
    #
    # @param [Integer] :id(required) Project id to be exported.
    # @option [String] :description Overrides the project description.
    # @option [String] :url Upload url for archive (required if :http_method is set).
    # @option [String] :http_method HTTP method to use for project upload (default: PUT).
    # @return [Gitlab::ObjectifiedHash] Status message for the export request.
    def project_export(id, description: nil, url: nil, http_method: nil)
      body = {}
      body[:upload] = { url: upload_url, http_method: http_method } if url || http_method
      body[:description] = description if description
      post("/projects/#{id}/export", body)
    end

    # Get project export status
    #
    # @example
    #    Gitlab.project_export_status(1)
    #
    # @param [Integer] :id Project id to check.
    # @return [Gitlab::ObjectifiedHash] Status information for the export job.
    def project_export_status(id)
      get("/projects/#{id}/export")
    end

    # Download exported project
    #
    # @example
    #    Gitlab.project_export_download(1)
    #
    # @param [Integer/String] :id Project id or path
    # @return [Gitlab::FileResponse]
    def project_export_download(id)
      get("/projects/#{id}/export/download",
          headers: { Accept: 'application/octet-stream' },
          parser: proc { |body, _|
                    if body.encoding == Encoding::ASCII_8BIT # binary response
                      ::Gitlab::FileResponse.new StringIO.new(body, 'rb+')
                    else # error with json response
                      ::Gitlab::Request.parse(body)
                    end
                  })
    end

    # Import a project
    #
    # @example
    #    Gitlab.project_import("/path/to/archive", "tribute")
    #
    # @param [String} :file Full path to file.
    # @param [String] :path Name and path for uploaded project
    # @option [Integer/String] :namespace ID or path of the namespace. Defaults to current user.
    # @option [String] :name Name of the project. Defaults to path.
    # @option [Boolean] :overwrite Overwrite an existing project
    # @option [Hash] :override_params Parameters to overide project settings @see Gitlab::Projects#create_project
    # @return [Gitlab::ObjectifiedHash] Status information for the import job.
    def project_import(file, path, opts = {})
      opts[:path] = path
      opts[:file] = File.open(file, 'rb')
      post('/projects/import', body: opts)
    end

    # Get the status of a project import.
    #
    # @example
    #    Gitlab.project_import_status(1)
    #    Gitlab.project_import_status("tribute")
    #
    # @param [Integer/String] :id Project id or path
    # @return [Gitlab::ObjectifiedHash] Status information for the import job.
    def project_import_status(id)
      get("/projects/#{id}/import")
    end
  end
end
