# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to project exports.
  # @see https://docs.gitlab.com/ce/api/project_import_export.html
  module ProjectExports
    # Start a new export
    #
    # @example
    #   Gitlab.export_project(2)
    #
    # @param [Integer, String] id The ID or path of a project.
    # @param [Hash] options A customizable set of options.
    # @option options [String] description(optional) Overrides the project description
    # @option options [hash] upload(optional) Hash that contains the information to upload the exported project to a web server
    # @option options [String] upload[url] TThe URL to upload the project
    # @option options [String] upload[http_method](optional) The HTTP method to upload the exported project. Only PUT and POST methods allowed. Default is PUT
    # @return [Gitlab::ObjectifiedHash]
    def export_project(id, options = {})
      post("/projects/#{url_encode id}/export", body: options)
    end

    # Get the status of export
    #
    # @example
    #   Gitlab.export_project_status(2)
    #
    # @param [Integer, String] id The ID or path of a project.
    # @return [Gitlab::ObjectifiedHash]
    def export_project_status(id)
      get("/projects/#{url_encode id}/export")
    end

    # Download the finished export
    #
    # @example
    #   Gitlab.exported_project_download(2)
    #
    # @param [Integer, String] id The ID or path of a project.
    # @return [Gitlab::FileResponse]
    def exported_project_download(id)
      get("/projects/#{url_encode id}/export/download",
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
  end
end
